class Api::VoiceConversationController < ApplicationController
  before_action :find_stakeholder_by_token
  before_action :find_session
  protect_from_forgery with: :null_session
  
  def start_session
    service = OpenaiRealtimeService.new(@stakeholder)
    session_config = service.create_conversation_session
    
    render json: {
      success: true,
      session: session_config.except(:api_key, :authorization),
      message: "Voice conversation session started"
    }
  end
  
  def get_realtime_config
    session_id = params[:session_id]
    service = OpenaiRealtimeService.new(@stakeholder)
    config = service.get_webrtc_config(session_id)
    
    if config
      render json: {
        success: true,
        config: config
      }
    else
      render json: {
        success: false,
        error: "Session not found"
      }, status: :not_found
    end
  end
  
  def update_transcript
    session_id = params[:session_id]
    transcript_entry = {
      type: params[:type], # 'user_speech', 'ai_speech', 'user_text', 'ai_text'
      content: params[:content],
      speaker: params[:speaker] # 'user' or 'assistant'
    }
    
    service = OpenaiRealtimeService.new(@stakeholder)
    result = service.update_conversation_transcript(session_id, transcript_entry)
    
    if result[:error]
      render json: {
        success: false,
        error: result[:error]
      }, status: :bad_request
    else
      render json: {
        success: true,
        conversation_turn: result[:conversation_turn],
        message: "Transcript updated"
      }
    end
  end
  
  def process_audio
    # Legacy endpoint - redirect to use WebRTC approach
    render json: {
      success: false,
      message: "Audio processing now handled via WebRTC. Use WebSocket connection to OpenAI Realtime API.",
      redirect_to_realtime: true
    }
  end
  
  def send_text_message
    # For testing purposes, allow text input to be processed as speech transcript
    message = params[:message]
    session_id = params[:session_id]
    
    transcript_entry = {
      type: 'user_text',
      content: message,
      speaker: 'user'
    }
    
    service = OpenaiRealtimeService.new(@stakeholder)
    result = service.update_conversation_transcript(session_id, transcript_entry)
    
    if result[:error]
      render json: {
        success: false,
        error: result[:error]
      }
    else
      render json: {
        success: true,
        user_message: message,
        message: "Text message processed as transcript entry",
        conversation_turn: result[:conversation_turn],
        note: "For voice responses, use WebRTC connection to OpenAI Realtime API"
      }
    end
    
  rescue => e
    Rails.logger.error "Voice conversation error: #{e.message}"
    
    render json: {
      success: false,
      error: "Failed to process message"
    }, status: :internal_server_error
  end
  
  def end_session
    session_id = params[:session_id]
    
    service = OpenaiRealtimeService.new(@stakeholder)
    result = service.end_conversation_session(session_id)
    
    # Finalize assessment transcript
    if @stakeholder.assessment
      finalize_assessment_transcript
    end
    
    render json: {
      success: true,
      session_ended: result[:session_ended],
      final_message: result[:final_message],
      conversation_summary: result[:conversation_summary]
    }
  end
  
  def session_status
    session_id = params[:session_id]
    service = OpenaiRealtimeService.new(@stakeholder)
    session_config = service.get_session_config(session_id)
    
    render json: {
      session_active: session_config.present?,
      session_config: session_config&.except(:api_key, :authorization)
    }
  end
  
  private
  
  def find_stakeholder_by_token
    @stakeholder = Stakeholder.find_by(invitation_token: params[:token])
    unless @stakeholder
      render json: { error: "Invalid token" }, status: :not_found
    end
  end
  
  def find_session
    @session_id = params[:session_id]
  end
  
  def finalize_assessment_transcript
    assessment = @stakeholder.assessment
    return unless assessment
    
    final_summary = "\n\n--- Voice Assessment API Session Ended at #{Time.current.strftime('%Y-%m-%d %H:%M:%S')} ---"
    final_summary += "\nDuration: #{assessment.duration_minutes} minutes"
    final_summary += "\nParticipant: #{@stakeholder.name} (#{@stakeholder.email})"
    final_summary += "\nCompany: #{@stakeholder.company.name}"
    final_summary += "\nAssessment Type: Voice-to-Voice AI Interview"
    
    assessment.update!(
      full_transcript: (assessment.full_transcript || "") + final_summary
    )
  end
end 