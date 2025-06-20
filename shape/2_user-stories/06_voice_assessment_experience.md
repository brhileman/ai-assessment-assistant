# User Story: Voice Assessment Experience

**As a** company stakeholder  
**I want** to participate in a natural voice conversation about AI readiness  
**So that** I can share my insights without the burden of lengthy forms

## Context
Stakeholders prefer conversational interfaces over traditional surveys for sharing detailed business insights. The AI agent is guided by any custom instructions provided by the company during setup.

## Scenarios

### Happy Path
1. System shows assessment landing page with "Start Assessment" button
2. Stakeholder clicks "Start Assessment" button
3. System requests microphone permission
4. Stakeholder grants microphone access
5. AI agent greets stakeholder and explains the process (using company custom instructions if provided)
6. "Finish Assessment" button is visible throughout conversation
7. Stakeholder engages in natural conversation covering:
   - Their role and responsibilities
   - Key metrics they manage
   - Current technology stack
   - AI adoption experience
   - Organizational readiness factors
   - Implementation challenges
8. When ready, stakeholder clicks "Finish Assessment" button
9. System shows brief confirmation dialog ("Are you sure you want to finish?")
10. Stakeholder confirms and proceeds to completion page

### Edge Cases
- User hesitates to start: "Start Assessment" button remains available until clicked
- Microphone permission denied: Show clear instructions to enable access with retry option
- Poor audio quality: AI agent asks for clarification politely
- Conversation interruption: Allow resume from last topic
- Very brief responses: AI agent asks follow-up questions naturally
- Accidental finish click: Confirmation dialog prevents premature completion
- Early completion: Allow finishing even if not all topics covered

## Acceptance Criteria
- [ ] Assessment landing page with clear "Start Assessment" button
- [ ] Microphone permission request triggered by user action
- [ ] Professional AI agent greeting and introduction
- [ ] AI agent incorporates company custom instructions (if provided) into conversation approach
- [ ] Natural conversation flow covering all assessment areas
- [ ] "Finish Assessment" button always visible and accessible during conversation
- [ ] Brief confirmation dialog before completing assessment
- [ ] Real-time transcript display during conversation
- [ ] Conversation interruption and resume capability
- [ ] User controls both when conversation starts and ends
- [ ] 15-30 minute typical conversation duration

## Key Screens
- Assessment landing page with "Start Assessment" button
- Microphone permission request page
- Voice conversation interface with transcript and "Finish" button
- Confirmation dialog ("Are you sure you want to finish?")
- Assessment completion page

## MVP Decisions
- **Conversation ending**: User-controlled via "Finish Assessment" button (not AI-managed)
- **Completion control**: Stakeholder decides when they're done talking
- **No review/edit**: Direct completion without transcript editing
- **No pause functionality**: Keep interface simple for MVP 