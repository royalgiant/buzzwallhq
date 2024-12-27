module Auth
  class ShopifyController < ApplicationController
    def callback
      @shop_domain = params[:shop]
      
      if @shop_domain.present?
        begin
          Rails.logger.info "Starting token exchange for shop: #{@shop_domain}"
          access_token = get_access_token(@shop_domain)
          Rails.logger.info "Got access token: #{access_token}"
          
          # Then use this access token for API calls
          session = ShopifyAPI::Auth::Session.new(
            shop: @shop_domain,
            access_token: access_token
          )

          client = ShopifyAPI::Clients::Rest::Admin.new(session: session)
          
          webhook_url = "https://engaged-dane-accepted.ngrok-free.app/webhooks/shopify"

          ['app_subscriptions/create', 'app_subscriptions/update', 'app_subscriptions/approaching_capped_amount'].each do |topic|
            begin
              client.post(
                path: '/admin/api/2024-01/webhooks.json',
                body: {
                  webhook: {
                    topic: 'app_subscriptions/update',
                    address: webhook_url,
                    format: 'json'
                  }
                }
              )
              Rails.logger.info "Successfully registered webhook for app_subscriptions/update"
            rescue => e
              Rails.logger.error "Failed to register webhook for #{topic}: #{e.message}"
            end
          end
        rescue => e
          Rails.logger.error "Failed to register webhooks: #{e.message}"
        end
        
        theme_editor_url = "https://#{@shop_domain}/admin/themes/current/editor?context=apps&template=index&activateAppId=#{Rails.application.credentials.dig(Rails.env.to_sym, :shopify, :api_key)}/blocks/buzzwall"
        render 'successful_installation', locals: { theme_editor_url: theme_editor_url }
      else
        redirect_to '/home'
      end
    end

    private

    def get_access_token(shop_domain)
      client_id = Rails.application.credentials.dig(Rails.env.to_sym, :shopify, :api_key)
      client_secret = Rails.application.credentials.dig(Rails.env.to_sym, :shopify, :api_secret)
    
      # The post body needs to include:
      # - grant_type: client_credentials
      # - client_id: your app's client ID
      # - client_secret: your app's client secret
      # - scope: your app's OAuth scopes
      uri = URI("https://#{shop_domain}/admin/oauth/access_token")
      response = Net::HTTP.post(uri, {
        grant_type: 'client_credentials',
        client_id: client_id,
        client_secret: client_secret,
        scope: 'write_products,read_products' # Add the scopes your app needs
      }.to_json, 'Content-Type' => 'application/json')
    
      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)['access_token']
      else
        Rails.logger.error "Token exchange failed: #{response.body}"
        raise "Failed to get access token: #{response.body}"
      end
    end
  end
end