class Admin::AssessmentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_assessment, only: [:show]
  before_action :set_company, only: [:show], if: -> { params[:company_id].present? }
  
  def index
    @assessments = Assessment.includes(:stakeholder => :company)
                            .where.not(completed_at: nil)
                            .order(completed_at: :desc)
    @total_assessments = @assessments.count
    @companies_with_assessments = @assessments.joins(:stakeholder => :company).distinct.count('companies.id')
  end

  def show
    # Handle case where assessment doesn't exist
    unless @assessment
      redirect_to admin_root_path, alert: "Assessment not found"
      return
    end
    
    # Set company context if not already set (for direct assessment access)
    @company ||= @assessment.stakeholder.company
    
    # Handle incomplete assessments
    unless @assessment.completed?
      redirect_to admin_company_path(@company), 
                  alert: "Assessment is not yet completed. Stakeholder: #{@assessment.stakeholder.name}"
      return
    end
    
    # Handle missing transcript
    unless @assessment.has_transcript?
      redirect_to admin_company_path(@company),
                  alert: "Assessment transcript is not available. Stakeholder: #{@assessment.stakeholder.name}"
      return
    end
  end
  
  private
  
  def set_assessment
    @assessment = Assessment.find_by(id: params[:id])
  end
  
  def set_company
    @company = Company.find_by(id: params[:company_id])
    unless @company
      redirect_to admin_root_path, alert: "Company not found"
      return
    end
  end
end
