# app/controllers/shopify_controller.rb
class ShopifyController < ApplicationController
  include ShopifyApp::LoginProtection
  
  def install
    # Called when a merchant clicks "Install" in Shopify
    if request.post?
      authenticate_with_shopify
    else
      render :install
    end
  end
  
  def callback
    # OAuth callback from Shopify
    shop_domain = params[:shop]
    access_token = ShopifyApp::SessionRepository.retrieve_access_token(session[:shopify])
    
    # Link installation to current BuzzwallHQ user
    store = current_user.shopify_stores.create!(
      shop_domain: shop_domain,
      access_token: access_token,
      embed_token: params[:embed_token] # Or get from user's existing walls
    )
    
    redirect_to dashboard_path, notice: 'Shopify store connected!'
  end
  
  def configure
    @store = current_user.shopify_stores.find_by!(shop_domain: params[:shop])
    @walls = current_user.walls # Your existing walls relationship
  end
  
  def update
    @store = current_user.shopify_stores.find_by!(shop_domain: params[:shop])
    @store.update!(embed_token: params[:embed_token])
    
    # Reinstall script tag with new token
    @store.send(:install_script_tag)
    
    redirect_to dashboard_path, notice: 'Store configuration updated!'
  end
end