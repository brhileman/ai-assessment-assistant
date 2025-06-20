class AssessmentController < ApplicationController
  layout 'public'
  before_action :find_stakeholder_by_token
  
  def show
    @company = @stakeholder.company
    
    # Check if assessment is already completed
    if @stakeholder.assessment&.completed?
      redirect_to assessment_completed_path(@stakeholder.invitation_token)
      return
    end
    
    # Check if assessment is already started
    if @stakeholder.assessment&.present?
      redirect_to voice_assessment_path(@stakeholder.invitation_token)
      return
    end
  end
  
  def start
    # Create assessment for this stakeholder
    @assessment = Assessment.create!(
      stakeholder: @stakeholder
    )
    
    # Update stakeholder status
    @stakeholder.update!(status: :assessment_started)
    
    # Redirect to voice assessment interface
    redirect_to voice_assessment_path(@stakeholder.invitation_token)
  end
  
  def assessment_already_completed
    @company = @stakeholder.company
    @assessment = @stakeholder.assessment
  end
  
  private
  
  def find_stakeholder_by_token
    @stakeholder = Stakeholder.find_by(invitation_token: params[:token])
    unless @stakeholder
      render 'errors/invalid_token', status: :not_found
    end
  end
end 