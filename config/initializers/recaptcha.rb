Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials[Rails.env.to_sym].dig(:google, :recaptcha_site_key_v2)
  config.secret_key = Rails.application.credentials[Rails.env.to_sym].dig(:google, :recaptcha_secret_key_v2)
end
