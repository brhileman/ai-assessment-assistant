class Admin::StakeholdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_company, except: [:index]
  before_action :find_stakeholder, only: [:destroy, :resend_invitation]
  layout 'admin'

  def index
    @stakeholders = Stakeholder.includes(:company, :assessment).order(created_at: :desc)
    @total_stakeholders = @stakeholders.count
    @completed_assessments = @stakeholders.joins(:assessment).where.not(assessments: { completed_at: nil }).count
    @pending_assessments = @total_stakeholders - @completed_assessments
  end

  def new
    @stakeholder = @company.stakeholders.build
  end

  def create
    @stakeholder = @company.stakeholders.build(stakeholder_params)
    
    if @stakeholder.save
      # Create associated assessment
      @stakeholder.create_assessment!
      
      # Send invitation email
      begin
        AssessmentMailer.stakeholder_invitation(@stakeholder).deliver_now
        @stakeholder.update_column(:invitation_sent_at, Time.current)
        flash[:notice] = "Stakeholder #{@stakeholder.name} has been added and invitation email sent to #{@stakeholder.email}."
      rescue => e
        Rails.logger.error "Failed to send invitation email to #{@stakeholder.email}: #{e.message}"
        flash[:notice] = "Stakeholder #{@stakeholder.name} has been added, but there was an issue sending the invitation email. Please try resending."
      end
      
      redirect_to admin_company_path(@company)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def resend_invitation
    begin
      AssessmentMailer.stakeholder_invitation(@stakeholder).deliver_now
      @stakeholder.update_column(:invitation_sent_at, Time.current)
      flash[:notice] = "Invitation email resent to #{@stakeholder.name} (#{@stakeholder.email})."
    rescue => e
      Rails.logger.error "Failed to resend invitation email to #{@stakeholder.email}: #{e.message}"
      flash[:alert] = "Failed to resend invitation email. Please try again or contact support."
    end
    
    redirect_to admin_company_path(@company)
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
