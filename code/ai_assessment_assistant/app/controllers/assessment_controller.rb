class AssessmentController < ApplicationController
  before_action :find_stakeholder_by_token, only: [:show, :start]
  before_action :check_assessment_status, only: [:show, :start]
  
  def show
    @company = @stakeholder.company
    @assessment_started = @stakeholder.assessment&.present? && @stakeholder.assessment.started_at.present?
  end
  
  def start
    # Check if stakeholder already has an assessment
    if @stakeholder.assessment.present?
      redirect_to assessment_path(@stakeholder.invitation_token), 
                  alert: "Unable to start assessment. Please try again."
      return
    end
    
    @assessment = @stakeholder.build_assessment(started_at: Time.current)
    if @assessment.save
      @stakeholder.update(status: :assessment_started)
      redirect_to voice_assessment_path(@stakeholder.invitation_token)
    else
      redirect_to assessment_path(@stakeholder.invitation_token), 
                  alert: "Unable to start assessment. Please try again."
    end
  end
  
  private
  
  def find_stakeholder_by_token
    @stakeholder = Stakeholder.find_by(invitation_token: params[:token])
    unless @stakeholder
      render 'errors/invalid_token', status: :not_found
    end
  end
  
  def check_assessment_status
    if @stakeholder&.assessment&.completed?
      render 'assessment_already_completed'
    end
  end
end
