class Admins::MagicLinksController < ApplicationController
  before_action :set_admin, only: [:show]
  
  def new
    # Show the email input form for requesting magic link
  end
  
  def create
    @admin = Admin.find_by(email: admin_params[:email])
    
    if @admin
      @admin.send_magic_link(request, { remember_me: params[:admin][:remember_me] })
      redirect_to admin_magic_link_sent_path, notice: 'Magic link sent! Check your email for the login link.'
    else
      flash.now[:alert] = 'Email address not found or not authorized for admin access.'
      render :new
    end
  end
  
  def show
    # Show the "magic link sent" confirmation page
  end
  
  def verify
    token = params[:admin_magic_link_token]
    remember_me = params[:remember_me]
    
    if token.blank?
      redirect_to new_admin_magic_link_path, alert: 'Invalid magic link. Please request a new one.'
      return
    end
    
    # Find admin by magic link token - we need to encrypt the raw token to match what's stored
    encrypted_token = Devise.token_generator.digest(Admin, :magic_link_token, token)
    admin = Admin.find_by(magic_link_token: encrypted_token)
    
    if admin.nil?
      redirect_to new_admin_magic_link_path, alert: 'Invalid magic link. Please request a new one.'
    elsif admin.magic_link_expired?
      redirect_to new_admin_magic_link_path, alert: 'Magic link has expired. Please request a new one.'
    else
      # Sign in the admin
      sign_in(admin, remember: remember_me == '1')
      
      # Clear the magic link token so it can't be used again
      admin.update!(magic_link_token: nil, magic_link_sent_at: nil)
      
      redirect_to admin_root_path, notice: 'Successfully signed in!'
    end
  end
  
  private
  
  def admin_params
    params.require(:admin).permit(:email, :remember_me)
  end
  
  def set_admin
    # For the show action, we don't need a specific admin
  end
end 