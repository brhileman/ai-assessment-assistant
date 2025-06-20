class VoiceAssessmentController < ApplicationController
  before_action :find_stakeholder_by_token
  before_action :ensure_assessment_started
  before_action :check_assessment_not_completed
  
  def show
    @company = @stakeholder.company
    @assessment = @stakeholder.assessment
    @assessment_duration = assessment_duration_minutes
    
    # Create OpenAI session for real-time conversation
    @openai_session = OpenaiRealtimeService.new(@stakeholder).create_conversation_session
  end
  
  def complete
    @assessment = @stakeholder.assessment
    
    # Update assessment with completion data
    @assessment.update!(
      completed_at: Time.current,
      full_transcript: params[:final_transcript] || "Assessment completed via voice interface"
    )
    
    # Update stakeholder status
    @stakeholder.update!(status: :assessment_completed)
    
    # TODO: Send completion email when mailer is available
    # AssessmentMailer.assessment_completed(@stakeholder, @assessment).deliver_later
    
    redirect_to assessment_completed_path(@stakeholder.invitation_token)
  end
  
  private
  
  def find_stakeholder_by_token
    @stakeholder = Stakeholder.find_by(invitation_token: params[:token])
    unless @stakeholder
      render 'errors/invalid_token', status: :not_found
    end
  end
  
  def ensure_assessment_started
    unless @stakeholder&.assessment&.present?
      redirect_to assessment_path(@stakeholder.invitation_token),
                  alert: "Please start your assessment first."
    end
  end
  
  def check_assessment_not_completed
    if @stakeholder&.assessment&.completed?
      redirect_to assessment_completed_path(@stakeholder.invitation_token)
    end
  end
  
  def assessment_duration_minutes
    return 0 unless @assessment&.created_at
    ((Time.current - @assessment.created_at) / 1.minute).round
  end
end
