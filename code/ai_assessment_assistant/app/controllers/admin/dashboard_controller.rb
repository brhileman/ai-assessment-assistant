class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    # Admin dashboard home page
    @admin = current_admin
  end
  
  private
  
  def authenticate_admin!
    redirect_to new_admin_magic_link_path unless admin_signed_in?
  end
end 