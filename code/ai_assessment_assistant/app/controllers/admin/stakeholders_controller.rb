class Admin::StakeholdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_company
  before_action :find_stakeholder, only: [:destroy]
  layout 'admin'

  def new
    @stakeholder = @company.stakeholders.build
  end

  def create
    @stakeholder = @company.stakeholders.build(stakeholder_params)
    
    if @stakeholder.save
      # Create associated assessment
      @stakeholder.create_assessment!
      
      # Send invitation email (placeholder for now)
      # TODO: Implement email invitation in Task 5
      # Note: Stakeholder is already marked as 'invited' by default
      
      flash[:notice] = "Stakeholder #{@stakeholder.name} has been added and invitation sent."
      redirect_to admin_company_path(@company)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    stakeholder_name = @stakeholder.name
    @stakeholder.destroy
    
    flash[:notice] = "Stakeholder #{stakeholder_name} has been removed."
    redirect_to admin_company_path(@company)
  end

  private

  def find_company
    @company = Company.find(params[:company_id])
  end

  def find_stakeholder
    @stakeholder = @company.stakeholders.find_by!(invitation_token: params[:id])
  end

  def stakeholder_params
    params.require(:stakeholder).permit(:name, :email)
  end
end
