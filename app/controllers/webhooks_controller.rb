class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_shopify_webhook, only: :shopify

  def create
    # docs: https://stripe.com/docs/payments/checkout/fulfill-orders
    # receive POST from Stripe
    payload = request.body.read
    signature_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials[Rails.env.to_sym].dig(:stripe, :webhook_signing_secret)
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, signature_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: {message: e}, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: {message: e}, status: 400
      return
    end

    # Handle the event
    case event.type
    when 'checkout.session.completed', 'charge.succeeded'
      # If a user doesn't exist we definitely don't want to subscribe them
      return if !User.exists?(event.data.object.client_reference_id)
      # Payment is successful and the subscription is created.
      # Provision the subscription and save the customer ID to your database.
      fullfill_order(event.data.object)
    when 'invoice.payment_succeeded'
      # return if a subscription id isn't present on the invoice
      return unless event.data.object.subscription.present?
      # Continue to provision the subscription as payments continue to be made.
      # Store the status in your database and check when a user accesses your service.
      stripe_subscription = Stripe::Subscription.retrieve(event.data.object.subscription)
      subscription = Subscription.find_by(subscription_id: stripe_subscription)

      subscription.update(
        current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
        current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
        plan_id: stripe_subscription.plan.id,
        interval: stripe_subscription.plan.interval,
        status: stripe_subscription.status,
      )
      # Stripe can send an email here for invoice paid attempts. Configure in your account OR roll your own below
    when 'invoice.payment_failed'
      # The payment failed or the customer does not have a valid payment method.
      # The subscription becomes past_due so we need to notify the customer and send them to the customer portal to update their payment information.

      # Find the user by stripe id or customer id from Stripe event response
      user = User.find_by(stripe_id: event.data.object.customer)
      # Send an email to that customer detailing the problem with instructions on how to solve it.
      if user.present?
        SubscriptionMailer.with(user: user).payment_failed.deliver_now
      end
    when 'customer.subscription.updated'
      # deletion
      stripe_subscription = event.data.object

      subscription = Subscription.find_by(subscription_id: stripe_subscription.id)

      if subscription.present?
        # update the local subscription data with the status and other details that may have changed.
        subscription.update(
          current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
          current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
          interval: stripe_subscription.plan.interval,
          plan_id: stripe_subscription.plan.id,
          status: stripe_subscription.status
        )
      end
    else
      puts "Unhandled event type: #{event.type}"
    end
    render json: { message: 'Success' }, status: :ok
  end

  def shopify
    webhook_payload = JSON.parse(request.body.read)
    
    case request.headers['X-Shopify-Topic']
    when 'app/subscriptions/update'
      handle_shopify_subscription_update(webhook_payload)
    when 'app/subscriptions/create'
      handle_shopify_subscription_create(webhook_payload)
    when 'app/subscriptions/cancel'
      handle_shopify_subscription_cancel(webhook_payload)
    end

    render json: { message: 'Success' }, status: :ok
  end

  private

  def verify_shopify_webhook
    shopify_hmac = request.headers['X-Shopify-Hmac-Sha256']
    webhook_payload = request.body.read
    calculated_hmac = Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', Rails.application.credentials[Rails.env.to_sym].dig(:shopify, :api_secret), webhook_payload))
    
    unless ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, shopify_hmac)
      head :unauthorized
      return
    end
    
    request.body.rewind
  end

  def handle_shopify_subscription_create(payload)
    # Generate store name from domain
    shop_domain = payload['shop_domain']
    store_name = shop_domain.split('.')[0]
    
    # Generate temporary password
    temp_password = SecureRandom.hex(10)
    
    # Create user with validation skipping
    user = User.new(
      email: "#{store_name}@#{shop_domain}",
      password: temp_password,
      first_name: store_name.titleize,
      last_name: 'Store',
      skip_validation: true,
      role: determine_role_from_plan(payload['plan_id'])
    )
    
    # Skip email confirmation for Shopify users
    user.skip_confirmation!
    user.save!

    # Create subscription
    Subscription.create!(
      user: user,
      subscription_id: payload['subscription_id'],
      customer_id: payload['shop_id'],
      plan_id: payload['plan_id'],
      status: 'active',
      interval: payload['billing_interval'],
      current_period_start: Time.current,
      current_period_end: payload['billing_on'],
      source: 'shopify'
    )

    # Send welcome email with credentials
    UserMailer.with(
      user: user,
      temp_password: temp_password
    ).shopify_welcome.deliver_later

    # Send password in separate email for security
    UserMailer.with(
      user: user,
      temp_password: temp_password
    ).shopify_password.deliver_later
  end

  def handle_shopify_subscription_update(payload)
    subscription = Subscription.find_by(subscription_id: payload['subscription_id'])
    return unless subscription.present?

    subscription.update(
      status: payload['status'],
      current_period_end: payload['billing_on']
    )
  end

  def handle_shopify_subscription_cancel(payload)
    subscription = Subscription.find_by(subscription_id: payload['subscription_id'])
    return unless subscription.present?

    subscription.update(status: 'cancelled')
  end

  def fullfill_order(checkout_session)
    # Find user and assign customer id from Stripe
    user = User.find(checkout_session.client_reference_id)
    user.update(stripe_id: checkout_session.customer)

    # Retrieve new subscription via Stripe API using susbscription id
    stripe_subscription = Stripe::Subscription.retrieve(checkout_session.subscription)

    # Create new subscription with Stripe subscription details and user data
    Subscription.create(
      customer_id: stripe_subscription.customer,
      current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
      current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
      plan_id: stripe_subscription.plan.id,
      interval: stripe_subscription.plan.interval,
      status: stripe_subscription.status,
      subscription_id: stripe_subscription.id,
      user_id: user.id,
    )
  end

  def determine_role_from_plan(plan_id)
    # Add your Shopify plan IDs here
    case plan_id
    when '143497' # Starter
      User::STARTER
    when '143498' # Launch
      User::LAUNCH
    when '143499' # Grow
      User::GROW
    else
      nil
    end
  end
end


## Stripe Tutorial Reference: https://web-crunch.com/posts/stripe-checkout-billing-portal-ruby-on-rails
## If testing in local, make sure to use ngrok and replace `webhook_signing_secret` in credentials via value from `stripe listen --forward-to localhost:3000/webhooks`