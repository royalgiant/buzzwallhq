Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials[Rails.env.to_sym].dig(:stripe, :publishable_key),
  secret_key: Rails.application.credentials[Rails.env.to_sym].dig(:stripe, :secret_key)
}

Stripe.api_key = Rails.application.credentials[Rails.env.to_sym].dig(:stripe, :secret_key)