# Task 7: Voice Assessment Interface & OpenAI Integration

**Prerequisites:** Task 6 (Stakeholder Landing Pages) must be completed

## Task Overview
Implement the core voice assessment interface using OpenAI Realtime API, featuring our modern glassmorphism design with real-time transcript display, animated wave visualizer, and user-controlled conversation flow.

## Reference Documentation
- **User Story 6**: Voice Assessment Experience in `../2_user-stories/`
- **User Story 7**: Real-Time Transcript Viewing in `../2_user-stories/`
- **Design System**: Modern voice interface components in `../3_design-system/`
- **Voice Interface Mockup**: Final design in `../3_design-system/voice_assessment_mockup_modern.html`

## Tasks

- [ ] 1.0 Set Up OpenAI Realtime API Integration
  - [ ] 1.1 Configure OpenAI credentials and API keys
  - [ ] 1.2 Create OpenAI service class for Realtime API
  - [ ] 1.3 Set up WebSocket connection management
  - [ ] 1.4 Implement audio stream handling
  - [ ] 1.5 Add error handling for API failures
  - [ ] 1.6 Test basic API connectivity and authentication

- [ ] 2.0 Create Voice Assessment Controller and Routes
  - [ ] 2.1 Generate VoiceAssessmentController: `rails generate controller VoiceAssessment show`
  - [ ] 2.2 Set up voice assessment routes with token validation
  - [ ] 2.3 Add WebSocket endpoint for real-time communication
  - [ ] 2.4 Implement session management for assessment state
  - [ ] 2.5 Add CSRF and security protections
  - [ ] 2.6 Test controller and routing functionality

- [ ] 3.0 Build Modern Voice Interface Layout
  - [ ] 3.1 Create voice assessment view using modern design system
  - [ ] 3.2 Implement glassmorphism card layout with gradient background
  - [ ] 3.3 Add fixed header with LaunchPad Lab logo
  - [ ] 3.4 Create mobile-first responsive design (max-width 28rem)
  - [ ] 3.5 Add company context display section
  - [ ] 3.6 Implement assessment status indicators
  - [ ] 3.7 Test layout responsiveness across devices

- [ ] 4.0 Implement Futuristic Wave Visualizer
  - [ ] 4.1 Create 10-bar animated wave visualizer component
  - [ ] 4.2 Add Cyan → Blue → Dark Blue gradient styling
  - [ ] 4.3 Implement pulsing glow effects with dual-color shadows
  - [ ] 4.4 Add shimmer animation with white light sweep
  - [ ] 4.5 Create dynamic height randomization with JavaScript
  - [ ] 4.6 Add wave animation timing (1.8s cycle with delays)
  - [ ] 4.7 Test visual performance and smooth animations

- [ ] 5.0 Create Voice Control Interface
  - [ ] 5.1 Implement three-button control layout (Settings • Mic • End)
  - [ ] 5.2 Add central 64px microphone button with gradient background
  - [ ] 5.3 Create 48px settings and end assessment buttons
  - [ ] 5.4 Add hover effects with translateY(-2px) and shadows
  - [ ] 5.5 Implement microphone permission request flow
  - [ ] 5.6 Add recording state visual feedback
  - [ ] 5.7 Test button interactions and visual feedback

- [ ] 6.0 Build Real-Time Transcript Display
  - [ ] 6.1 Create transcript container with custom scrolling
  - [ ] 6.2 Implement AI and User message bubbles with avatars
  - [ ] 6.3 Add gradient AI avatars (Blue to Cyan) and slate user avatars
  - [ ] 6.4 Create timestamp display for each message
  - [ ] 6.5 Add typing indicator with bouncing dots
  - [ ] 6.6 Implement auto-scroll to latest messages
  - [ ] 6.7 Test transcript updates and visual consistency

- [ ] 7.0 Integrate OpenAI Realtime Conversation
  - [ ] 7.1 Set up audio input capture from user microphone
  - [ ] 7.2 Configure OpenAI Realtime API for conversation mode
  - [ ] 7.3 Pass company custom instructions to AI agent
  - [ ] 7.4 Implement real-time audio streaming to OpenAI
  - [ ] 7.5 Process AI responses and audio output
  - [ ] 7.6 Handle conversation state and context management
  - [ ] 7.7 Test complete conversation flow

- [ ] 8.0 Add Transcript Management and Storage
  - [ ] 8.1 Capture and store conversation transcript in real-time
  - [ ] 8.2 Format transcript with speaker identification
  - [ ] 8.3 Add timestamp information for each exchange
  - [ ] 8.4 Implement transcript validation and error handling
  - [ ] 8.5 Save progressive transcript updates to database
  - [ ] 8.6 Handle incomplete or corrupted transcript scenarios
  - [ ] 8.7 Test transcript accuracy and completeness

- [ ] 9.0 Implement Assessment Completion Flow
  - [ ] 9.1 Add "Finish Assessment" button with confirmation modal
  - [ ] 9.2 Update assessment completion timestamp
  - [ ] 9.3 Save final transcript to database
  - [ ] 9.4 Update stakeholder status to "assessment_completed"
  - [ ] 9.5 Trigger completion email sending
  - [ ] 9.6 Create assessment completion confirmation page
  - [ ] 9.7 Test complete assessment workflow

- [ ] 10.0 Error Handling and Fallbacks
  - [ ] 10.1 Handle microphone access denied scenarios
  - [ ] 10.2 Manage OpenAI API connection failures
  - [ ] 10.3 Add network connectivity error handling
  - [ ] 10.4 Implement assessment recovery mechanisms
  - [ ] 10.5 Create user-friendly error messages
  - [ ] 10.6 Add technical support contact options
  - [ ] 10.7 Test error scenarios and recovery paths

- [ ] 11.0 Testing and Quality Assurance
  - [ ] 11.1 Write unit tests for OpenAI service integration
  - [ ] 11.2 Create controller tests for voice assessment flow
  - [ ] 11.3 Test real-time transcript functionality
  - [ ] 11.4 Verify assessment completion and data storage
  - [ ] 11.5 Test across different browsers and devices
  - [ ] 11.6 Validate audio quality and performance
  - [ ] 11.7 Perform end-to-end system testing

## Implementation Details

### OpenAI Service Class
```ruby
class OpenAIRealtimeService
  include HTTParty
  
  def initialize(stakeholder)
    @stakeholder = stakeholder
    @company = stakeholder.company
    @api_key = Rails.application.credentials.openai[:api_key]
  end
  
  def create_conversation_session
    # Set up WebSocket connection to OpenAI Realtime API
    # Configure AI agent with company custom instructions
    # Return session identifier for frontend connection
  end
  
  def process_audio_stream(audio_data)
    # Send audio stream to OpenAI
    # Process real-time responses
    # Return transcript and audio response
  end
  
  private
  
  def conversation_instructions
    base_instructions = """
    You are conducting an AI readiness assessment interview. 
    Focus on understanding the participant's:
    - Current role and responsibilities
    - Technology usage and comfort level
    - Perspectives on AI adoption
    - Organizational readiness for AI initiatives
    
    Keep the conversation natural and engaging. Ask follow-up questions based on responses.
    """
    
    if @company.custom_instructions.present?
      base_instructions + "\n\nCompany-specific context:\n#{@company.custom_instructions}"
    else
      base_instructions
    end
  end
end
```

### Voice Assessment Controller
```ruby
class VoiceAssessmentController < ApplicationController
  before_action :find_stakeholder_by_token
  before_action :ensure_assessment_started
  
  def show
    @company = @stakeholder.company
    @assessment = @stakeholder.assessment
    @openai_session = OpenAIRealtimeService.new(@stakeholder).create_conversation_session
  end
  
  def complete
    @assessment = @stakeholder.assessment
    @assessment.update!(
      completed_at: Time.current,
      full_transcript: params[:final_transcript]
    )
    
    @stakeholder.update!(status: :assessment_completed)
    
    # Send completion email
    AssessmentMailer.assessment_completed(@stakeholder, @assessment).deliver_later
    
    render :completed
  end
  
  private
  
  def find_stakeholder_by_token
    @stakeholder = Stakeholder.find_by(invitation_token: params[:token])
    render 'errors/invalid_token', status: :not_found unless @stakeholder
  end
  
  def ensure_assessment_started
    unless @stakeholder.assessment.present?
      redirect_to assessment_path(@stakeholder.invitation_token),
                  alert: "Please start your assessment first."
    end
  end
end
```

## File Tracking

### Files to Create
| File Path | Purpose | Task Ref | Status |
|-----------|---------|----------|--------|
| `app/controllers/voice_assessment_controller.rb` | Voice assessment flow | 2.1 | ⏳ |
| `app/views/voice_assessment/show.html.erb` | Main voice interface | 3.1 | ⏳ |
| `app/views/voice_assessment/completed.html.erb` | Completion confirmation | 9.6 | ⏳ |
| `app/services/open_ai_realtime_service.rb` | OpenAI API integration | 1.2 | ⏳ |
| `app/assets/javascripts/voice_assessment.js` | Frontend voice functionality | 4.1 | ⏳ |
| `app/assets/javascripts/wave_visualizer.js` | Wave animation component | 4.1 | ⏳ |
| `app/assets/javascripts/transcript_manager.js` | Transcript display logic | 6.1 | ⏳ |
| `app/channels/voice_assessment_channel.rb` | WebSocket for real-time updates | 2.3 | ⏳ |
| `spec/services/open_ai_realtime_service_spec.rb` | Service tests | 11.1 | ⏳ |
| `spec/controllers/voice_assessment_controller_spec.rb` | Controller tests | 11.2 | ⏳ |
| `spec/system/voice_assessment_spec.rb` | End-to-end tests | 11.7 | ⏳ |

### Files to Modify
| File Path | Changes | Task Ref | Status |
|-----------|---------|----------|--------|
| `config/routes.rb` | Add voice assessment routes | 2.2 | ⏳ |
| `config/cable.yml` | Configure Action Cable | 2.3 | ⏳ |
| `app/models/assessment.rb` | Add completion methods | 9.2 | ⏳ |

## JavaScript Components

### Wave Visualizer Implementation
```javascript
// app/assets/javascripts/wave_visualizer.js
class WaveVisualizer {
  constructor(container) {
    this.container = container;
    this.bars = this.createBars();
    this.startAnimation();
  }
  
  createBars() {
    const bars = [];
    for (let i = 0; i < 10; i++) {
      const bar = document.createElement('div');
      bar.className = 'wave-bar';
      bar.style.animationDelay = `${i * 0.1}s`;
      this.container.appendChild(bar);
      bars.push(bar);
    }
    return bars;
  }
  
  startAnimation() {
    setInterval(() => {
      this.bars.forEach(bar => {
        const height = Math.random() * 32 + 6;
        bar.style.height = `${height}px`;
      });
    }, 1500);
  }
  
  updateWithAudioLevel(level) {
    // Update visualization based on actual audio input level
    this.bars.forEach((bar, index) => {
      const intensity = level * (1 - Math.abs(index - 5) / 5);
      const height = Math.max(6, intensity * 40);
      bar.style.height = `${height}px`;
    });
  }
}
```

## Success Criteria

- [ ] Voice assessment interface matches modern design mockup exactly
- [ ] OpenAI Realtime API integration works smoothly
- [ ] Real-time transcript displays accurately during conversation
- [ ] Wave visualizer provides engaging visual feedback
- [ ] Assessment completion flow saves data correctly
- [ ] Mobile experience is optimized and functional
- [ ] Error handling provides clear guidance to users
- [ ] All tests pass including end-to-end system tests

## Performance Considerations

- **Audio Quality**: Ensure clear audio capture and playback
- **Real-time Updates**: Minimize latency in transcript display
- **Animation Performance**: Use hardware acceleration for smooth visuals
- **Memory Management**: Handle long conversations without memory leaks
- **Network Efficiency**: Optimize WebSocket communication
- **Battery Usage**: Consider mobile device power consumption

## Security Considerations

- **API Key Security**: Protect OpenAI credentials
- **Audio Privacy**: Ensure secure audio transmission
- **Session Management**: Prevent unauthorized access to conversations
- **Data Encryption**: Encrypt sensitive conversation data
- **Rate Limiting**: Prevent API abuse

## Next Steps

After Task 7 completion:
- Task 8: Complete assessment results and admin review features
- Task 9: Final testing, security, and Heroku deployment
- The voice interface represents the core user experience of our application 