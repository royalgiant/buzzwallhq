module Webhooks
  class ComplianceController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :verify_webhook

    def shop_redacted
      # Since we don't store shop data, just acknowledge
      head :ok
    end

    def customer_redacted
      # Since we don't store customer data, just acknowledge
      head :ok
    end

    def data_request
      # Since we don't store any personal data, just acknowledge
      head :ok
    end

    private

    def verify_webhook
      hmac = request.headers['X-Shopify-Hmac-Sha256']
      data = request.body.read
      calculated_hmac = Base64.strict_encode64(
        OpenSSL::HMAC.digest(
          'sha256',
          Rails.application.credentials.dig(Rails.env.to_sym, :shopify, :api_secret),
          data
        )
      )
      
      unless ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, hmac)
        head :unauthorized
        return
      end
      
      request.body.rewind
    end
  end
end