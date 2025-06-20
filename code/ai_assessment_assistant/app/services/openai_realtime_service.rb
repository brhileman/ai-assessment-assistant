class OpenaiRealtimeService
  def initialize(stakeholder)
    @stakeholder = stakeholder
    @company = stakeholder.company
    
    # Handle credentials safely
    openai_credentials = Rails.application.credentials.openai
    if openai_credentials.nil?
      raise "OpenAI credentials section not found in Rails credentials"
    end
    
    @api_key = openai_credentials[:api_key]
    @organization_id = openai_credentials[:organization_id]
    
    raise "OpenAI API key not found in credentials" if @api_key.blank?
  end
  
  def create_conversation_session
    session_id = SecureRandom.uuid
    
    # Generate ephemeral token for secure WebRTC connection
    ephemeral_token = generate_ephemeral_token
    
    # Configure session for WebRTC Realtime API
    session_config = {
      session_id: session_id,
      ephemeral_token: ephemeral_token[:client_secret][:value],
      api_endpoint: "https://api.openai.com/v1/realtime",
      model: "gpt-4o-realtime-preview-2024-10-01",
      voice: "echo",
      instructions: conversation_instructions,
      company_name: @company.name,
      stakeholder_name: @stakeholder.name,
      conversation_history: [],
      session_expires_at: 1.minute.from_now # Ephemeral tokens expire in 1 minute
    }
    
    # Store session for later retrieval
    Rails.cache.write("openai_session_#{session_id}", session_config, expires_in: 2.hours)
    
    session_config
  end

  def update_conversation_transcript(session_id, transcript_entry)
    session_config = Rails.cache.read("openai_session_#{session_id}")
    return { error: "Session not found" } unless session_config
    
    # Add to conversation history
    conversation_history = session_config[:conversation_history] || []
    conversation_history << {
      timestamp: Time.current.iso8601,
      type: transcript_entry[:type], # 'user_speech', 'ai_speech', 'user_text', 'ai_text'
      content: transcript_entry[:content],
      speaker: transcript_entry[:speaker]
    }
    
    session_config[:conversation_history] = conversation_history
    Rails.cache.write("openai_session_#{session_id}", session_config, expires_in: 2.hours)
    
    # Update assessment with real-time transcript
    update_assessment_transcript(transcript_entry)
    
    {
      success: true,
      conversation_turn: conversation_history.length
    }
  end

  def get_webrtc_config(session_id)
    session_config = Rails.cache.read("openai_session_#{session_id}")
    return nil unless session_config
    
    # Check if ephemeral token is still valid (they expire in 1 minute)
    if session_config[:session_expires_at] < Time.current
      # Generate new ephemeral token
      ephemeral_token = generate_ephemeral_token
      session_config[:ephemeral_token] = ephemeral_token[:client_secret][:value]
      session_config[:session_expires_at] = 1.minute.from_now
      Rails.cache.write("openai_session_#{session_id}", session_config, expires_in: 2.hours)
    end
    
    # Return configuration needed for frontend WebRTC connection
    {
      ephemeral_token: session_config[:ephemeral_token],
      api_endpoint: session_config[:api_endpoint],
      model: session_config[:model],
      voice: session_config[:voice],
      instructions: session_config[:instructions],
      session_expires_at: session_config[:session_expires_at].iso8601
    }
  end

  def process_audio_stream(session_id, audio_data)
    # This method is now handled by WebRTC peer connection in frontend
    # Backend receives transcripts via update_conversation_transcript
    {
      message: "Audio processing handled by WebRTC peer connection",
      session_active: true
    }
  end
  
  def get_session_config(session_id)
    Rails.cache.read("openai_session_#{session_id}")
  end
  
  def end_conversation_session(session_id)
    session_config = Rails.cache.read("openai_session_#{session_id}")
    return false unless session_config
    
    begin
      conversation_history = session_config[:conversation_history] || []
      
      # Generate conversation summary
      summary = generate_conversation_summary(conversation_history)
      
      # Finalize assessment transcript
      finalize_assessment_transcript(conversation_history)
      
      # Clean up session
      Rails.cache.delete("openai_session_#{session_id}")
      
      {
        session_ended: true,
        final_message: "Thank you for participating in the AI readiness assessment. Your insights will help #{@company.name} understand their AI opportunities better.",
        conversation_summary: summary
      }
      
    rescue => e
      Rails.logger.error "Error ending conversation: #{e.message}"
      Rails.cache.delete("openai_session_#{session_id}")
      
      {
        session_ended: true,
        final_message: "Thank you for participating in the AI readiness assessment. Your insights will help #{@company.name} understand their AI opportunities better."
      }
    end
  end
  
  # Test method to verify API credentials work
  def test_connection
    # Test basic API access and ephemeral token generation
    ephemeral_token = generate_ephemeral_token
    if ephemeral_token && ephemeral_token[:client_secret]
      { success: true, message: "API connection and ephemeral token generation working" }
    else
      raise "Failed to generate ephemeral token"
    end
  rescue => e
    raise "OpenAI API connection failed: #{e.message}"
  end
  
  private
  
  def generate_ephemeral_token
    # Generate ephemeral token for secure client-side WebRTC connection
    uri = URI("https://api.openai.com/v1/realtime/sessions")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{@api_key}"
    request['Content-Type'] = "application/json"
    
    request.body = JSON.generate({
      model: "gpt-4o-realtime-preview-2024-10-01",
      voice: "echo"
    })
    
    response = http.request(request)
    
    if response.code == '200'
      JSON.parse(response.body, symbolize_names: true)
    else
      raise "Failed to generate ephemeral token: #{response.code} #{response.body}"
    end
  end
  
  def conversation_instructions
    base_instructions = <<~INSTRUCTIONS
      Hello! I'm LaunchPad Lab's AI early discovery assistant, and I've been trained to help us understand #{@company.name}'s AI readiness. 

      MY ROLE:
      I work with LaunchPad Lab's consulting team to conduct initial discovery conversations that help identify AI opportunities and readiness factors. This conversation will take about 5-10 minutes and helps our team understand how we might best support #{@company.name}.

      PARTICIPANT CONTEXT:
      - Name: #{@stakeholder.name}
      - Company: #{@company.name}
      - Role: #{@stakeholder.email.split('@').first.humanize} (inferred from email)

      CONVERSATION FLOW (5-10 minutes total):

      OPENING (1 minute):
      - Warm greeting: "Hi #{@stakeholder.name}! I'm LaunchPad Lab's trained AI discovery assistant."
      - Brief explanation: "I'll ask a few questions to understand #{@company.name}'s current situation and AI interests. This should take about 5-10 minutes."
      - "Let's start with your role - what are your main responsibilities at #{@company.name}?"

      CORE DISCOVERY AREAS (8 minutes total):

      1. ROLE & CURRENT CHALLENGES (2-3 minutes):
      Essential Questions:
      - "What are your main responsibilities at #{@company.name}?"

      2. TECHNOLOGY STACK & PROCESSES (2-3 minutes):
      Essential Questions:
      - "What technology systems & platforms do you and your team use daily in your work?"

      3. AI AWARENESS & INTEREST (2-3 minutes):
      Essential Questions:
      - "Do you currently use AI in your day to day operations?"
      - "If so, tell me more about how you use it?"
      - "Are there certain opportunities where you think AI could be helpful that you currently don't have the time or resources to explore?"
      - "Organizationally, what are the biggest challenges AI adoption is or might face?"

      CONVERSATION GUIDELINES:

      LaunchPad Lab Voice & Tone:
      - Professional consultant representing LaunchPad Lab
      - Warm but efficient - respect their time
      - Position as early discovery assistant that will help LaunchPad Lab focus further interviews and research
      - "We help companies identify and implement AI solutions"

      Response Style:
      - Keep responses to 1 sentence maximum
      - Only ask follow up questions if they didn't provide a clear answer to the essential question
      - Don't provide AI solutions or recommendations
      - Focus on discovery and understanding their situation

      Active Discovery Techniques:
      - "Can you give me a specific example of that?"
      - "Tell me more about that?"
      - "Can you dive a little deeper on that?"

      Time Management:
      - Keep each topic to 2-3 minutes maximum
      - If they're brief, ask more detail only if needed
      - If they're very detailed, gently transition: "That's really helpful. Let me ask about..."
      - Natural transitions: "Building on that, I'm curious about..."

      Closing (30 seconds):
      - "This has been really insightful for understanding #{@company.name}'s situation."
      - "Our team will review these insights to help inform our next steps in our AI readiness assessment."
      - Let them know they control when to finish with the "Finish Assessment" button

      IMPORTANT LAUNCHPAD LAB GUIDELINES:
      - I represent LaunchPad Lab's consulting expertise
      - This is early discovery in our AI readiness assessment process
      - Focus on understanding their challenges and current state
      - Do NOT provide solutions or recommendations during discovery
      - Position this as helping LaunchPad Lab understand how we can best support them
      - Keep it professional but conversational
      - Respect their time - this is a brief discovery conversation

      The user controls when the conversation ends via the "Finish Assessment" button. Keep the conversation flowing efficiently while gathering key discovery insights.
    INSTRUCTIONS
    
    if @company.custom_instructions.present?
      base_instructions + "\n\nCOMPANY-SPECIFIC DISCOVERY FOCUS:\n#{@company.custom_instructions}\n\nIncorporate this context naturally into your discovery questions and conversation flow."
    else
      base_instructions
    end
  end
  
  def update_assessment_transcript(transcript_entry)
    return unless @stakeholder.assessment
    
    assessment = @stakeholder.assessment
    current_transcript = assessment.full_transcript || ""
    
    timestamp = Time.current.strftime("%H:%M:%S")
    speaker_label = transcript_entry[:speaker] == 'user' ? @stakeholder.name : 'AI Assistant'
    
    new_entry = "\n[#{timestamp}] #{speaker_label}: #{transcript_entry[:content]}"
    
    assessment.update!(
      full_transcript: current_transcript + new_entry,
      last_activity_at: Time.current
    )
  end
  
  def finalize_assessment_transcript(conversation_history)
    assessment = @stakeholder.assessment
    return unless assessment
    
    final_summary = "\n\n--- WebRTC Voice Assessment Completed at #{Time.current.strftime('%Y-%m-%d %H:%M:%S')} ---"
    final_summary += "\nDuration: #{assessment.duration_minutes} minutes"
    final_summary += "\nParticipant: #{@stakeholder.name} (#{@stakeholder.email})"
    final_summary += "\nCompany: #{@stakeholder.company.name}"
    final_summary += "\nTotal exchanges: #{conversation_history.length}"
    final_summary += "\nConversation type: WebRTC Voice-to-Voice AI Assessment"
    
    assessment.update!(
      full_transcript: (assessment.full_transcript || "") + final_summary
    )
  end
  
  def generate_conversation_summary(conversation_history)
    user_messages = conversation_history.select { |msg| msg[:speaker] == 'user' }
    ai_messages = conversation_history.select { |msg| msg[:speaker] == 'assistant' }
    
    {
      total_exchanges: conversation_history.length,
      user_contributions: user_messages.length,
      ai_responses: ai_messages.length,
      conversation_duration_entries: conversation_history.length,
      key_themes: extract_key_themes(user_messages),
      conversation_type: "webrtc_voice_to_voice"
    }
  end
  
  def extract_key_themes(user_messages)
    # Simple keyword analysis for conversation themes
    content = user_messages.map { |msg| msg[:content] }.join(" ").downcase
    
    themes = []
    themes << "technology_usage" if content.match?(/\b(excel|email|software|tool|system|platform|tech)\b/)
    themes << "ai_interest" if content.match?(/\b(ai|artificial intelligence|automation|machine learning)\b/)
    themes << "team_dynamics" if content.match?(/\b(team|colleague|staff|employee|department|manage)\b/)
    themes << "process_improvement" if content.match?(/\b(process|workflow|efficiency|improvement|challenge)\b/)
    themes << "leadership" if content.match?(/\b(lead|manage|oversee|coordinate|supervise|director)\b/)
    themes << "innovation" if content.match?(/\b(innovation|new|change|future|digital|transform)\b/)
    
    themes
  end
end 