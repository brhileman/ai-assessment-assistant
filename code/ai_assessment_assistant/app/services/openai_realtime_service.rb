# Service for managing OpenAI Realtime API WebRTC voice conversations
# Handles session creation, ephemeral token generation, transcript management,
# and conversation flow for AI readiness assessments
class OpenaiRealtimeService
  # Configuration constants
  OPENAI_MODEL = "gpt-4o-realtime-preview-2024-10-01"
  OPENAI_VOICE = "shimmer"
  API_ENDPOINT = "https://api.openai.com/v1/realtime"
  SESSION_CACHE_DURATION = 2.hours
  TOKEN_EXPIRY_DURATION = 1.minute
  
  def initialize(stakeholder)
    @stakeholder = stakeholder
    @company = stakeholder.company
    
    # Handle credentials safely - check environment variables first (for production)
    @api_key = ENV['OPENAI_API_KEY'] || Rails.application.credentials.dig(:openai, :api_key)
    @organization_id = ENV['OPENAI_ORGANIZATION_ID'] || Rails.application.credentials.dig(:openai, :organization_id)
    
    raise "OpenAI API key not found in environment variables or credentials" if @api_key.blank?
  end
  
  def create_conversation_session
    session_id = SecureRandom.uuid
    
    # Generate ephemeral token for secure WebRTC connection
    ephemeral_token = generate_ephemeral_token
    
    # Configure session for WebRTC Realtime API
    session_config = {
      session_id: session_id,
      ephemeral_token: ephemeral_token[:client_secret][:value],
      api_endpoint: API_ENDPOINT,
      model: OPENAI_MODEL,
      voice: OPENAI_VOICE,
      instructions: conversation_instructions,
      company_name: @company.name,
      stakeholder_name: @stakeholder.name,
      conversation_history: [],
      session_expires_at: TOKEN_EXPIRY_DURATION.from_now
    }
    
    # Store session for later retrieval
    Rails.cache.write("openai_session_#{session_id}", session_config, expires_in: SESSION_CACHE_DURATION)
    
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
    Rails.cache.write("openai_session_#{session_id}", session_config, expires_in: SESSION_CACHE_DURATION)
    
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
    
    # Check if ephemeral token is still valid
    if session_config[:session_expires_at] < Time.current
      # Generate new ephemeral token
      ephemeral_token = generate_ephemeral_token
      session_config[:ephemeral_token] = ephemeral_token[:client_secret][:value]
      session_config[:session_expires_at] = TOKEN_EXPIRY_DURATION.from_now
      Rails.cache.write("openai_session_#{session_id}", session_config, expires_in: SESSION_CACHE_DURATION)
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
      model: OPENAI_MODEL,
      voice: OPENAI_VOICE
    })
    
    response = http.request(request)
    
    if response.code == '200'
      JSON.parse(response.body, symbolize_names: true)
    else
      raise "Failed to generate ephemeral token: #{response.code} #{response.body}"
    end
  end
  
  def conversation_instructions
    # Get company-specific instructions or use default context
    company_context = if @company.custom_instructions.present?
      @company.custom_instructions
    else
      "This is a general AI readiness assessment for #{@company.name}. Focus on understanding their current technology usage, operational challenges, and potential AI opportunities."
    end
    
    base_instructions = <<~INSTRUCTIONS
      Overview
      --------
      You are an interviewer from LaunchPad Lab. Your job is to run a warm, casually professional 15–20 minute discovery call with one business stakeholder.  
      Goal: Map how they work day‑to‑day (people, workflows, tools), surface friction and time sinks, and where AI might help.  
      Audience: #{@stakeholder.name} (use their first name in conversation).  
      CompanyContext: #{company_context}

      Affect: An empathetic, inquisitive facilitator with a light Midwestern American accent, coming across as a genuine colleague eager to learn from participants rather than interrogate them.
      Tone: Friendly and professional, combining conversational warmth with crisp articulation so it feels like talking to a thoughtful teammate, not a scripted robot.
      Pacing: Naturally fuctuation Mid tempo
      Handling Questions: Clearly signal questions through gentle upward intonation toward the sentence’s end, naturally prompting participants to respond
      Thoughtful Pausing: Occasionally pauses briefly (250–400 ms) mid-sentence, as if gathering thoughts, rather than speaking continuously without interruption.
      Reflective Tone: Slightly slows down and lowers pitch when repeating or summarizing participants' comments, giving a thoughtful and validating feel.
      Balanced Hesitations: Occasionally introduces a subtle hesitation ("uh," "um") when appropriate, sparingly, to enhance realism without undermining clarity.

      Opening
      -------
      Immediately casually greet the stakeholder by their first name then wait for a response. "Hey #{@stakeholder.name}, are you there?"
      
      Then briefly in a short sentence review the goal of the call.

      Discovery Flow (internal – guidance only)
      1. **Role & Team Snapshot** – size, functions, who reports to whom.  
      2. **Typical Week / Recent Project** – have them narrate an example.  
      3. **Workflow(s) Deep‑Dive** – pick key process(es) they mention; walk through triggers → steps → hand‑offs → outputs.  
      4. **Tools / Data Landscape** – systems used, data quality, gaps.  
      5. **Pain Points & Time Sinks** – quantify effort or delays; let them surface organically.  
      6. **AI Today & Tomorrow** – what’s already tried, appetite, resistance.

      Conversational Techniques
      • Follow the thread – when you hear a tool, metric, or gripe, ask one more “why / how / tell me more.”  
      • Active‑listening fillers – brief “yeah”, “for sure”, “cool” between larger stakeholder blocks.  
      • Reflect & confirm – “So it sounds like … Did I catch that right?”  
      • Quantify & example – “Rough ballpark is fine—how many deals a quarter?”  
      • Light self‑awareness – if you’ve spoken for >30 sec, say “I’ve been talking a lot—let me pause.”  
      • Context hook – weave in at least two details from #{company_context}.  
      • Talk‑time ratio – stakeholder ≥ 70 %. Invite stories if answers are short.

      Closing
      -------
      • Ask, "Is there anything we did not cover that you wish we had?"  
      • Thank them genuinely: “Really appreciate you walking me through all that.”
      • Remind them to click the "Finish Assessment" button to conclude.

    INSTRUCTIONS
    
    base_instructions
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