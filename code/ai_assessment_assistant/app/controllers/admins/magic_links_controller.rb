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
  
  private
  
  def admin_params
    params.require(:admin).permit(:email, :remember_me)
  end
  
  def set_admin
    # For the show action, we don't need a specific admin
  end
end 