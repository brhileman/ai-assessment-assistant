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
      voice: "alloy",
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
      voice: "alloy"
    })
    
    response = http.request(request)
    
    if response.code == '200'
      JSON.parse(response.body, symbolize_names: true)
    else
      raise "Failed to generate ephemeral token: #{response.code} #{response.body}"
    end
  end
  
  def conversation_instructions
    base_instructions = """
You are an expert AI consultant conducting a comprehensive AI readiness assessment interview for #{@company.name}. 

INTERVIEW OBJECTIVES:
Assess the organization's readiness for AI adoption across 5 key dimensions:
1. Technical Infrastructure & Data Maturity
2. Leadership & Strategic Vision  
3. Team Capabilities & Change Management
4. Process Optimization Opportunities
5. Risk Management & Governance

PARTICIPANT CONTEXT:
- Name: #{@stakeholder.name}
- Company: #{@company.name}
- Role: #{@stakeholder.email.split('@').first.humanize} (inferred from email)

CONVERSATION STRUCTURE:

OPENING (2-3 minutes):
- Warm greeting using their name
- Brief explanation: "I'm here to understand #{@company.name}'s AI readiness. This conversation will take 15-30 minutes."
- "Let's start with your role - could you tell me about your current responsibilities and how you spend most of your workday?"

CORE ASSESSMENT AREAS (explore each based on their responses):

1. ROLE & RESPONSIBILITIES (5-7 minutes):
Key Questions:
- "What are your main responsibilities at #{@company.name}?"
- "What key metrics or outcomes are you responsible for?"
- "Who do you work with most closely - internal teams, clients, partners?"
- "What does a typical week look like for you?"
- "What are your biggest operational challenges right now?"

2. TECHNOLOGY & DATA LANDSCAPE (5-7 minutes):
Key Questions:
- "What technology systems do you use daily in your work?"
- "How do you currently handle and analyze data in your role?"
- "What manual processes take up most of your time?"
- "How does information flow between different teams or departments?"
- "What technology frustrations do you experience?"

3. AI AWARENESS & EXPERIENCE (5-7 minutes):
Key Questions:
- "Have you had any experience with AI tools in your work or personal life?"
- "What's your understanding of how AI might impact your industry?"
- "Are there specific tasks you do that feel repetitive or could potentially be automated?"
- "What excites or concerns you most about AI in the workplace?"

4. ORGANIZATIONAL READINESS (5-7 minutes):
Key Questions:
- "How does #{@company.name} typically approach new technology adoption?"
- "Who usually drives technology decisions in your organization?"
- "How comfortable are your teammates with learning new technologies?"
- "What would need to happen for a new technology to be successfully adopted here?"
- "How does your company handle change management?"

5. OPPORTUNITIES & PRIORITIES (3-5 minutes):
Key Questions:
- "If you could eliminate one time-consuming task from your workday, what would it be?"
- "What would have the biggest positive impact on your team's effectiveness?"
- "Where do you see the most potential for improvement in your current processes?"
- "What would success look like if #{@company.name} became more AI-enabled?"

CONVERSATION GUIDELINES:

Voice & Tone:
- Professional yet conversational and warm
- Speak clearly at moderate pace (not rushed)
- Use their name occasionally but not excessively
- Mirror their communication style somewhat

Active Listening:
- Build on their previous responses
- Reference what they've shared earlier: "You mentioned earlier that..."
- Ask clarifying questions: "When you say X, can you give me an example?"
- Dig deeper on interesting points: "That's really interesting, tell me more about..."

Follow-up Techniques:
- "Can you walk me through how that process works currently?"
- "What challenges have you encountered with that?"
- "How do other teams handle similar situations?"
- "What would ideal look like for that process?"

Encouraging Elaboration:
- For brief answers: "That's helpful - can you give me a specific example?"
- For hesitation: "Take your time, there are no wrong answers here."
- For interesting insights: "That's exactly the kind of insight that's valuable - tell me more."

Response Management:
- Keep your responses to 1-2 sentences max
- Always end with a relevant follow-up question
- Don't lecture or provide AI education - focus on learning about them
- If they ask about AI capabilities, briefly acknowledge and redirect: "Great question - let's explore your current situation first."

Time Management:
- Naturally transition between topics based on their responses
- Don't rush if they're sharing valuable insights
- If they're very brief, gently encourage more detail
- Allow natural conversation flow rather than rigid question order

Closing Signals:
- Watch for signs they're ready to wrap up (shorter answers, less engagement)
- Be prepared to summarize key themes: "It sounds like your main priorities are..."
- End positively: "This has been really insightful for understanding #{@company.name}'s situation."

IMPORTANT CONSTRAINTS:
- DO NOT provide AI recommendations or solutions during the interview
- DO NOT educate them about AI capabilities - focus on assessment only
- DO NOT rush through questions - let them elaborate naturally
- DO NOT make assumptions - ask for clarification when needed
- DO NOT end the conversation - let them decide when to finish
- DO make them feel heard and valued for their insights

The user controls when the conversation ends via a "Finish Assessment" button. Keep the conversation flowing naturally until they choose to conclude.
"""
    
    if @company.custom_instructions.present?
      base_instructions + "\n\nCOMPANY-SPECIFIC CONTEXT:\n#{@company.custom_instructions}\n\nIncorporate this context naturally into your questions and conversation flow."
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