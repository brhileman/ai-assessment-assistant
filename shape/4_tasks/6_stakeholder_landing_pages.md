# Task 6: Stakeholder Landing Pages & Assessment Entry

**Prerequisites:** Task 5 (Email Invitation System) must be completed

## Task Overview
Create the stakeholder-facing landing pages and assessment entry flow. This includes the invitation landing page, pre-assessment information, and the bridge to the voice assessment interface using our modern design system.

## Reference Documentation
- **User Story 5**: Assessment Invitation Response in `../2_user-stories/`
- **User Story 6**: Voice Assessment Experience in `../2_user-stories/`
- **Design System**: Modern dark theme and glassmorphism in `../3_design-system/`

## Tasks

- [x] 1.0 Create Stakeholder Assessment Controller
  - [x] 1.1 Generate AssessmentController: `rails generate controller Assessment show start`
  - [x] 1.2 Set up UUID token-based routing
  - [x] 1.3 Add stakeholder lookup and validation
  - [x] 1.4 Handle invalid/expired tokens gracefully
  - [x] 1.5 Add security measures against token guessing
  - [x] 1.6 Test token validation and error handling

- [x] 2.0 Design Assessment Landing Page
  - [x] 2.1 Create responsive landing page using design system
  - [x] 2.2 Display company name and personalized greeting
  - [x] 2.3 Include assessment overview and expectations
  - [x] 2.4 Add estimated time and process explanation
  - [x] 2.5 Include LaunchPad Lab branding and trust indicators
  - [x] 2.6 Add privacy information and data usage notice
  - [ ] 2.7 Test landing page across devices and browsers

- [x] 3.0 Implement Pre-Assessment Information
  - [x] 3.1 Create assessment preparation section
  - [x] 3.2 Add technical requirements (microphone, browser support)
  - [x] 3.3 Include assessment topics and question types
  - [x] 3.4 Add tips for effective participation
  - [x] 3.5 Display company custom instructions if provided
  - [x] 3.6 Include contact information for support
  - [ ] 3.7 Test information clarity and completeness

- [x] 4.0 Create Assessment Start Flow
  - [x] 4.1 Add "Start Assessment" call-to-action button
  - [~] 4.2 Implement microphone permission request *(Will be handled in Task 7 - Voice Interface)*
  - [~] 4.3 Add browser compatibility checks *(Will be handled in Task 7 - Voice Interface)*
  - [~] 4.4 Create loading states for assessment initialization *(Will be handled in Task 7 - Voice Interface)*
  - [~] 4.5 Handle microphone access denied scenarios *(Will be handled in Task 7 - Voice Interface)*
  - [x] 4.6 Add technical troubleshooting information
  - [ ] 4.7 Test start flow on different browsers and devices

- [x] 5.0 Add Assessment Status Management
  - [x] 5.1 Track assessment start time and status
  - [x] 5.2 Update stakeholder status to "assessment_started"
  - [x] 5.3 Prevent multiple simultaneous assessments
  - [~] 5.4 Handle assessment resumption (if applicable) *(DEFERRED for MVP - one-shot assessments)*
  - [~] 5.5 Add assessment abandonment tracking *(Future enhancement)*
  - [x] 5.6 Create status indicators for admins
  - [x] 5.7 Test status updates and transitions

- [ ] 6.0 Implement Error Handling and Fallbacks
  - [ ] 6.1 Create custom error pages for common issues
  - [ ] 6.2 Handle technical incompatibility gracefully
  - [ ] 6.3 Add fallback contact options
  - [~] 6.4 Include alternative assessment methods if needed *(DEFERRED for MVP - voice-only focus)*
  - [ ] 6.5 Create clear error messaging
  - [ ] 6.6 Add automatic error reporting to admins
  - [ ] 6.7 Test error scenarios and recovery paths

- [ ] 7.0 Mobile Optimization and Responsive Design
  - [ ] 7.1 Optimize landing page for mobile devices
  - [ ] 7.2 Ensure touch-friendly interface elements
  - [ ] 7.3 Test microphone access on mobile browsers
  - [ ] 7.4 Optimize loading performance for slower connections
  - [ ] 7.5 Test across different mobile platforms
  - [ ] 7.6 Ensure consistent experience across screen sizes
  - [ ] 7.7 Validate accessibility on mobile devices

- [~] 8.0 Add Analytics and Tracking *(DEFERRED for MVP)*
  - [~] 8.1 Track landing page visits and conversions *(Future enhancement)*
  - [~] 8.2 Monitor assessment start rates *(Future enhancement)*
  - [x] 8.3 Track technical issues and failures *(Basic error logging only)*
  - [~] 8.4 Add funnel analysis for drop-off points *(Future enhancement)*
  - [~] 8.5 Monitor browser and device compatibility *(Future enhancement)*
  - [~] 8.6 Create admin dashboard for conversion metrics *(Future enhancement)*
  - [~] 8.7 Test analytics data collection and reporting *(Future enhancement)*

- [ ] 9.0 Testing and Quality Assurance
  - [ ] 9.1 Write controller tests for all stakeholder actions
  - [ ] 9.2 Create system tests for complete user journey
  - [ ] 9.3 Test token security and validation thoroughly
  - [ ] 9.4 Verify responsive design across devices
  - [ ] 9.5 Test microphone permission flows
  - [ ] 9.6 Validate error handling and recovery
  - [ ] 9.7 Perform accessibility testing

## Implementation Details

### Assessment Controller
```ruby
class AssessmentController < ApplicationController
  before_action :find_stakeholder_by_token, only: [:show, :start]
  before_action :check_assessment_status
  
  def show
    @company = @stakeholder.company
    @assessment_started = @stakeholder.assessment&.present?
  end
  
  def start
    @assessment = @stakeholder.build_assessment
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
```

### Routes Configuration
```ruby
# config/routes.rb
get '/assessment/:token', to: 'assessment#show', as: :assessment
post '/assessment/:token/start', to: 'assessment#start', as: :start_assessment
get '/voice/:token', to: 'voice_assessment#show', as: :voice_assessment
```

## File Tracking

### Files to Create
| File Path | Purpose | Task Ref | Status |
|-----------|---------|----------|--------|
| `app/controllers/assessment_controller.rb` | Stakeholder assessment flow | 1.1 | ⏳ |
| `app/views/assessment/show.html.erb` | Assessment landing page | 2.1 | ⏳ |
| `app/views/assessment/assessment_already_completed.html.erb` | Completed assessment page | 6.1 | ⏳ |
| `app/views/errors/invalid_token.html.erb` | Invalid token error page | 6.1 | ⏳ |
| `app/views/shared/_assessment_info.html.erb` | Assessment information partial | 3.1 | ⏳ |
| `app/views/shared/_technical_requirements.html.erb` | Technical requirements partial | 3.2 | ⏳ |
| `app/views/layouts/stakeholder.html.erb` | Stakeholder layout | 2.1 | ⏳ |
| `app/assets/javascripts/assessment_start.js` | Assessment start functionality | 4.2 | ⏳ |
| `spec/controllers/assessment_controller_spec.rb` | Controller tests | 9.1 | ⏳ |
| `spec/system/stakeholder_assessment_spec.rb` | Complete journey tests | 9.2 | ⏳ |

### Files to Modify
| File Path | Changes | Task Ref | Status |
|-----------|---------|----------|--------|
| `config/routes.rb` | Add stakeholder routes | 1.2 | ⏳ |
| `app/models/stakeholder.rb` | Add assessment methods | 5.1 | ⏳ |

## Landing Page Design

### Assessment Landing Page Layout
```erb
<!-- app/views/assessment/show.html.erb -->
<div class="min-h-screen gradient-bg flex items-center justify-center p-4">
  <div class="glass-card w-full max-w-md">
    <!-- Header with Logo -->
    <div class="text-center mb-8">
      <%= image_tag "White-Horizontal-LPL-Logo.svg", 
          alt: "LaunchPad Lab", 
          class: "h-12 mx-auto mb-6" %>
      <h1 class="text-2xl font-bold text-white mb-2">AI Assessment</h1>
      <p class="text-slate-300"><%= @company.name %></p>
    </div>
    
    <!-- Personalized Greeting -->
    <div class="mb-8">
      <h2 class="text-xl text-white mb-4">Hello, <%= @stakeholder.name %></h2>
      <p class="text-slate-200 leading-relaxed">
        You've been invited to participate in an AI readiness assessment. 
        This conversation will help us understand your role, current technology 
        usage, and perspectives on AI adoption.
      </p>
    </div>
    
    <!-- Assessment Information -->
    <div class="mb-8 space-y-4">
      <div class="bg-slate-800/30 rounded-lg p-4">
        <h3 class="text-white font-medium mb-2">What to expect:</h3>
        <ul class="text-slate-300 text-sm space-y-1">
          <li>• 10-15 minute voice conversation</li>
          <li>• Questions about your role and technology use</li>
          <li>• AI readiness and adoption perspectives</li>
          <li>• Real-time transcript provided</li>
        </ul>
      </div>
      
      <% if @company.custom_instructions.present? %>
        <div class="bg-slate-800/30 rounded-lg p-4">
          <h3 class="text-white font-medium mb-2">From <%= @company.name %>:</h3>
          <p class="text-slate-300 text-sm">
            <%= simple_format(@company.custom_instructions) %>
          </p>
        </div>
      <% end %>
    </div>
    
    <!-- Technical Requirements -->
    <div class="mb-8">
      <details class="bg-slate-800/30 rounded-lg">
        <summary class="p-4 text-white font-medium cursor-pointer">
          Technical Requirements
        </summary>
        <div class="px-4 pb-4 text-slate-300 text-sm">
          <ul class="space-y-1">
            <li>• Microphone access required</li>
            <li>• Modern browser (Chrome, Firefox, Safari, Edge)</li>
            <li>• Stable internet connection</li>
            <li>• Quiet environment preferred</li>
          </ul>
        </div>
      </details>
    </div>
    
    <!-- Start Assessment Button -->
    <div class="text-center">
      <% unless @assessment_started %>
        <%= button_to start_assessment_path(@stakeholder.invitation_token), 
            method: :post,
            class: "w-full bg-gradient-to-r from-lpl-blue to-lpl-cyan text-white py-3 px-6 rounded-lg font-medium hover:shadow-glow transition-all duration-300 transform hover:-translate-y-0.5",
            data: { confirm: "Ready to start your assessment?" } do %>
          Start Assessment
        <% end %>
      <% else %>
        <%= link_to voice_assessment_path(@stakeholder.invitation_token),
            class: "w-full bg-gradient-to-r from-lpl-blue to-lpl-cyan text-white py-3 px-6 rounded-lg font-medium hover:shadow-glow transition-all duration-300 transform hover:-translate-y-0.5 inline-block text-center" do %>
          Continue Assessment
        <% end %>
      <% end %>
    </div>
    
    <!-- Contact Information -->
    <div class="mt-8 text-center">
      <p class="text-slate-400 text-sm">
        Questions? Contact us at 
        <a href="mailto:assessment@launchpadlab.com" class="text-lpl-cyan hover:underline">
          assessment@launchpadlab.com
        </a>
      </p>
    </div>
  </div>
</div>
```

## Success Criteria

- [ ] Landing page loads correctly from email invitation links
- [ ] Stakeholder information displays accurately
- [ ] Assessment start flow works smoothly
- [ ] Microphone permission requests function properly
- [ ] Error handling provides clear guidance
- [ ] Mobile experience is optimized
- [ ] All tests pass including system tests
- [ ] Analytics track user behavior effectively

## Security Considerations

- **Token Validation**: Verify UUID tokens are valid and not expired
- **Rate Limiting**: Prevent abuse of assessment start endpoints
- **Session Management**: Maintain secure session state
- **Error Information**: Don't leak sensitive data in error messages
- **CSRF Protection**: Ensure all forms include CSRF tokens

## Next Steps

After Task 6 completion:
- Task 7: Implement the voice assessment interface with OpenAI Realtime API
- Task 8: Add real-time transcript and assessment completion features
- Landing pages provide the foundation for voice assessment experience 