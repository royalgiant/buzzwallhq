# app/controllers/auth/shopify_controller.rb
module Auth
  class ShopifyController < ApplicationController
    def callback
      @shop_domain = params[:shop]
      
      if @shop_domain.present?
        theme_editor_url = "https://#{@shop_domain}/admin/themes/current/editor?context=apps&template=index&activateAppId=#{Rails.application.credentials.dig(Rails.env.to_sym, :shopify, :api_key)}/blocks/buzzwall"
        render 'successful_installation', locals: { theme_editor_url: theme_editor_url }
      else
        redirect_to '/home'
      end
    end
  end
end