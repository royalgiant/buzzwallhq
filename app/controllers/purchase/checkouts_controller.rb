# app/controllers/purchase/checkouts_controller.rb
class Purchase::CheckoutsController < ApplicationController
  before_action :authenticate_user!
  def create
    price = params[:price_id] # passed in via the hidden field in pricing.html.erb
    mode = params[:mode]
    # https://stripe.com/docs/payments/checkout/free-trials
    if !mode.present?
      session = Stripe::Checkout::Session.create(
        customer: current_user.stripe_id,
        client_reference_id: current_user.id,
        success_url: root_url + "purchase/success?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: pricing_url,
        payment_method_types: ['card'],
        mode: 'subscription',
        customer_email: current_user.email,
        line_items: [{
          quantity: 1,
          price: price,
        }],
        subscription_data: {
          trial_settings: {end_behavior: {missing_payment_method: 'cancel'}},
          trial_period_days: 7,
        },
      )
    else
      session = Stripe::Checkout::Session.create(
        success_url: root_url + "purchase/success?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: get_payment_cancel_url(mode),
        payment_method_types: ['card'],
        mode: 'payment',
        customer_email: current_user.email,
        line_items: [{
          quantity: 1,
          price: price,
        }],
      )
    end
    #render json: { session_id: session.id } # if you want a json response
    redirect_to session.url, allow_other_host: true
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    if (@session.amount_total == 1000 || @session.amount_total == 2000 || @session.amount_total == 4000)
      user = User.find_or_initialize_by(email: @session.customer_email || @session.customer_details["email"])
      case @session.amount_total
      when 1000
        user.role = User::STARTER
      when 2000
        user.role = User::LAUNCH
      when 4000
        user.role = User::GROW
      end
      user.save(validate: false)
    end
    @customer = Stripe::Customer.retrieve(@session.customer) if @session.customer.present?
  end

  def get_payment_cancel_url(mode)
    root_url
  end
end