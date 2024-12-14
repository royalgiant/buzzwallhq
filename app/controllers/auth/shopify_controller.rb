# app/controllers/auth/shopify_controller.rb
module Auth
  class ShopifyController < ApplicationController
    def callback
      render 'successful_installation'
    end
  end
end