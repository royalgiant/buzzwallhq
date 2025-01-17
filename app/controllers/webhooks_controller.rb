class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

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
    app_subscription = webhook_payload["app_subscription"]
    
    if app_subscription["status"] == "ACTIVE"
      shop = ShopifyShop.find_by(shopify_gid: app_subscription["admin_graphql_api_shop_id"])
      user = User.find_by(email: shop.shopify_email)
      
      created_at = Time.parse(app_subscription["created_at"])
   
      subscription = Subscription.find_or_initialize_by(
        subscription_id: app_subscription["admin_graphql_api_id"]
      )
      
      period_start = created_at
      period_end = created_at + 1.month
      
      if subscription.new_record?
        # New subscription gets 7 day trial
        period_start = created_at + 7.days
        period_end = created_at + 37.days
        
        # Create user if doesn't exist
        unless user
          temp_password = SecureRandom.hex(10)
          user = User.new(
            email: shop.shopify_email,
            password: temp_password,
            first_name: shop.shopify_email.split('@').first,
            last_name: 'Store',
            skip_validation: true,
            role: determine_role_from_plan(app_subscription["name"]),
            account_type: User::SHOPIFY_TYPE
          )
          user.skip_confirmation!
          user.save!
          shop.update(user: user)
          
          UserMailer.with(user: user, temp_password: temp_password).shopify_welcome.deliver_later
          UserMailer.with(user: user, temp_password: temp_password).shopify_password.deliver_later
        end
      else
        user&.update(role: determine_role_from_plan(app_subscription["name"]), account_type: User::SHOPIFY_TYPE)
      end
   
      subscription.update!(
        user: user,
        customer_id: app_subscription["admin_graphql_api_shop_id"], 
        plan_id: app_subscription["name"].downcase,
        status: 'active',
        interval: 'month',
        current_period_start: period_start,
        current_period_end: period_end,
        source: User::SHOPIFY_TYPE
      )
    end
  
    render json: { message: 'Success' }, status: :ok
  end  

  private

  def fullfill_order(checkout_session)
    # Find user and assign customer id from Stripe
    user = User.find(checkout_session.client_reference_id)
    user.update(stripe_id: checkout_session.customer, account_type: User::STRIPE_TYPE)

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

  def determine_role_from_plan(plan_name)
    case plan_name
    when "Starter"
      User::STARTER
    when "Launch"
      User::LAUNCH
    when "Grow"
      User::GROW
    else
      User::STARTER  # Default to starter if plan isn't recognized
    end
  end
end


## Stripe Tutorial Reference: https://web-crunch.com/posts/stripe-checkout-billing-portal-ruby-on-rails
## If testing in local, make sure to use ngrok and replace `webhook_signing_secret` in credentials via value from `stripe listen --forward-to localhost:3000/webhooks`