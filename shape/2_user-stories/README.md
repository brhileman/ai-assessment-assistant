# AI Assessment Assistant - User Stories Index

This directory contains all user stories for the AI Assessment Assistant, organized in logical implementation and flow order.

## 📋 Admin Setup & Management (Stories 1-3)

Core admin functionality to get started:

1. **[Admin Authentication](./01_admin_authentication.md)** - Passwordless magic link login using Devise
2. **[Company Management](./02_company_management.md)** - Creating and managing client companies
3. **[Stakeholder Invitation Management](./03_stakeholder_invitation_management.md)** - Sending assessment invitations and tracking

## 🔧 Technical Architecture (Story 4)

Core system architecture:

4. **[Stakeholder Data Linking](./04_stakeholder_data_linking.md)** - Technical architecture for linking invites to stakeholders and results

## 👥 Stakeholder Experience Flow (Stories 5-8)

Complete stakeholder journey in chronological order:

5. **[Assessment Invitation Response](./05_stakeholder_invitation_response.md)** - Accessing the assessment from email invitations
6. **[Voice Assessment Experience](./06_voice_assessment_experience.md)** - Main AI conversation flow covering all assessment topics
7. **[Real-Time Transcript Viewing](./07_real_time_transcript_viewing.md)** - Live transcription display during conversation
8. **[Assessment Completion](./08_assessment_completion.md)** - Completion confirmation and thank you flow

## 📊 Admin Results & Review (Story 9)

Post-assessment admin functionality:

9. **[Assessment Results Review](./09_assessment_results_review.md)** - Viewing and analyzing conversation transcripts

## ⚙️ System Requirements (Stories 10-11)

Cross-cutting technical requirements:

10. **[System Performance](./10_system_performance.md)** - Performance requirements for voice interface and web app
11. **[Data Security](./11_data_security.md)** - Security requirements for protecting client data

## 🚀 Implementation Priority

### Phase 1: Core Admin Setup (Stories 1-4)
- [ ] 01 - Admin Authentication
- [ ] 02 - Company Management  
- [ ] 03 - Stakeholder Invitation Management
- [ ] 04 - Stakeholder Data Linking

### Phase 2: Stakeholder Experience (Stories 5-8)
- [ ] 05 - Assessment Invitation Response
- [ ] 06 - Voice Assessment Experience
- [ ] 07 - Real-Time Transcript Viewing
- [ ] 08 - Assessment Completion

### Phase 3: Admin Review & Polish (Stories 9-11)
- [ ] 09 - Assessment Results Review
- [ ] 10 - System Performance
- [ ] 11 - Data Security

All stories are in planning phase and ready for implementation.

## 🎯 Key MVP Constraints

Important limitations and decisions for the MVP:

- **One Assessment Per Stakeholder**: Each stakeholder can only complete one assessment (not multiple over time)
- **No Invitation Expiration**: Assessment invitations remain valid indefinitely 
- **Admin Account Creation**: Manual admin setup only (no public registration)
- **Simple UI**: Default Devise views and basic styling for speed of implementation

## �� Story Format

Each story follows a consistent format:
- **User story statement** (As a... I want... So that...)
- **Context** - Background and rationale
- **Scenarios** - Happy path and edge cases
- **Acceptance Criteria** - Specific, testable requirements
- **Key Screens** - Main UI components involved
- **Questions** - Open items for clarification

## 🔄 Story Status Tracking

Use the acceptance criteria checkboxes in each story to track implementation progress. Mark items as complete when they pass testing and review.

## 📚 Related Documentation

- [PRD (Product Requirements Document)](../1_big-picture/prd.md)
- [Application Flowchart](../1_big-picture/flowchart.md)
- [Design System](../3_design-system/) *(coming next)*
- [Implementation Tasks](../4_tasks/) *(coming next)* 