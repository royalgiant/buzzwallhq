Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials.dig(Rails.env.to_sym, :google, :recaptcha_site_key_v2)
  config.secret_key = Rails.application.credentials.dig(Rails.env.to_sym, :google, :recaptcha_secret_key_v2)
end
