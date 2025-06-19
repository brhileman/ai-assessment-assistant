# AI Assessment Assistant

A voice-based web application for conducting initial client interviews as part of LaunchPad Lab's AI assessment program.

## Project Overview

The AI Assessment Assistant streamlines LaunchPad Lab's client onboarding process by replacing traditional surveys with natural voice conversations. Stakeholders receive email invitations to participate in AI-guided interviews that gather comprehensive information about their organization's AI readiness.

### Key Features
- **Admin Dashboard**: Company and stakeholder management
- **Email Invitations**: Automated stakeholder outreach via SendGrid
- **Voice Interface**: Natural conversations using OpenAI Realtime API
- **Real-time Transcripts**: Live conversation display
- **Assessment Results**: Transcript review and export capabilities

## Nova Project Structure

This project follows the **Nova framework** for structured product development:

```
ai_assessment_assistant/
├── shape/              # Product documentation (separate git repo)
│   ├── 1_big-picture/    # PRD and flowchart
│   ├── 2_user-stories/   # Detailed user requirements  
│   ├── 3_design-system/  # UI/UX standards and mockups
│   └── 4_tasks/          # Implementation tasks
└── code/               # Application code (each app has own repo)
    └── [future Rails app]
```

### Repository Architecture
- **Main Repository**: Project structure and coordination
- **Shape Repository**: Documentation and design (independent versioning)
- **Code Repositories**: Each application maintains its own repository

## Technology Stack

- **Backend**: Rails 8, PostgreSQL, Devise (passwordless)
- **Frontend**: Tailwind CSS, Flowbite, Stimulus controllers
- **Voice**: OpenAI Realtime API
- **Email**: SendGrid
- **Hosting**: Heroku
- **Authentication**: Magic link authentication for admins

## Current Status

✅ **Completed Phases:**
- [x] Big Picture: PRD and user journey flowchart
- [x] User Stories: 11 detailed stories with acceptance criteria
- [x] Design System: LaunchPad Lab branding and voice interface components
- [x] Voice Interface Mockup: Complete HTML prototype

⏳ **Next Phase:**
- [ ] Task breakdown and implementation planning
- [ ] Rails application generation
- [ ] MVP development

## Documentation Highlights

### Big Picture
- **PRD**: 3 key objectives, 2 user personas, 8 prioritized features
- **Flowchart**: Complete user journeys from admin setup to assessment completion

### User Stories (11 Stories)
1. **Admin Authentication**: Passwordless magic links with allowlist
2. **Company Management**: CRUD with custom AI instructions
3. **Stakeholder Invitation Management**: SendGrid email system
4. **Stakeholder Data Linking**: UUID token architecture
5. **Stakeholder Invitation Response**: Email-to-assessment flow
6. **Voice Assessment Experience**: User-controlled conversations
7. **Real-time Transcript Viewing**: Live conversation display
8. **Assessment Completion**: User-driven completion flow
9. **Assessment Results Review**: Basic transcript viewing/export
10. **System Performance**: Basic monitoring approach
11. **Data Security**: Essential security without over-engineering

### Design System
- **Brand Colors**: LaunchPad Lab blue (#1E60BD), charcoal, grays
- **Typography**: Proxima Nova hierarchy optimized for voice interfaces
- **Components**: Voice-specific elements (transcript, visualizer, controls)
- **Mockup**: Interactive HTML prototype of voice assessment interface

## Getting Started

### Prerequisites
- Git
- GitHub account
- Text editor/IDE

### Repository Setup

Since GitHub CLI is not available, please manually create the GitHub repositories:

#### 1. Main Repository Setup
```bash
# Current directory: /ai_assessment_assistant
# Already initialized and committed

# Create new repository on GitHub:
# Name: ai-assessment-assistant
# Description: AI Assessment Assistant - Voice-based web application for conducting initial client interviews as part of LaunchPad Lab's AI assessment program
# Public repository

# Then connect it:
git remote add origin https://github.com/[your-username]/ai-assessment-assistant.git
git branch -M main
git push -u origin main
```

#### 2. Shape Repository Setup  
```bash
# Navigate to shape directory
cd shape

# Create new repository on GitHub:
# Name: ai-assessment-assistant-shape
# Description: Documentation and design system for AI Assessment Assistant
# Public repository

# Then connect it:
git remote add origin https://github.com/[your-username]/ai-assessment-assistant-shape.git
git branch -M main
git push -u origin main
```

### Development Workflow

1. **Documentation Changes**: Work in `shape/` repository
2. **Implementation**: Create Rails app in `code/` with its own repository
3. **Task Management**: Update progress in `shape/4_tasks/`
4. **Coordination**: Use main repository for project-level coordination

## Project Vision

Transform LaunchPad Lab's client assessment process from time-intensive manual surveys to engaging 15-30 minute voice conversations that gather comprehensive AI readiness data while providing an exceptional client experience.

**Target Outcomes:**
- 70% reduction in assessment preparation time
- Enhanced data quality through natural conversation
- Improved client engagement and satisfaction
- Streamlined consultant workflow

## Contributing

This project follows Nova framework conventions:
- Complete documentation phases before implementation
- Maintain traceability from user stories to code
- Focus on user value in every decision
- Keep implementations simple unless specified otherwise

## License

Private project for LaunchPad Lab.

---

**Next Steps**: Create GitHub repositories using the instructions above, then proceed to task breakdown and Rails application generation. 