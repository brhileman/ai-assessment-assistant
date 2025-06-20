# User Story: Assessment Completion

**As a** company stakeholder  
**I want** clear confirmation that my assessment is complete  
**So that** I know my input was successfully recorded and what happens next

## Context
Stakeholders need closure and confidence that their time investment was valuable and properly recorded. Conversation completion is user-driven with a simple "Finish" button.

## Scenarios

### Happy Path - User Clicks "Finish"
1. During voice conversation, stakeholder decides they're ready to end
2. Stakeholder clicks "Finish Assessment" button visible on screen
3. System immediately displays completion confirmation page
4. Page confirms assessment was successfully saved
5. Simple thank you message acknowledging their participation
6. System sends thank you follow-up email via SendGrid

### Alternative Completion Methods
- **Timeout completion**: System prompts after period of inactivity with "Finish Assessment" button
- **Page close/exit**: Graceful handling if user navigates away

### Edge Cases
- Technical issues during saving: Show error with retry option
- Accidental finish click: Brief confirmation dialog "Are you sure you want to finish?"
- Email delivery issues: SendGrid handles delivery and bounce management

## Acceptance Criteria
- [ ] Prominent "Finish Assessment" button visible throughout conversation
- [ ] Simple confirmation dialog to prevent accidental completion
- [ ] Clear completion confirmation message
- [ ] Confirmation that assessment was successfully saved
- [ ] Thank you message acknowledging their participation
- [ ] Automated thank you email sent via SendGrid
- [ ] Contact information for follow-up questions

## Key Screens
- Assessment completion/thank you page
- Brief confirmation dialog ("Are you sure you want to finish?")

## Technical Considerations
- "Finish Assessment" button always visible and accessible
- Simple one-click completion (with confirmation)
- Timeout handling for inactive sessions
- Graceful handling of page navigation/closing
- SendGrid integration for thank you email delivery

## MVP Scope
Core functionality only - save assessment, confirm completion, and send thank you email. Future enhancements could include:
- Summary of topics covered
- Timeline for results

## Questions
- [ ] What's the appropriate timeout duration for inactive sessions? 30 mins
- [ ] Should we warn if conversation seems very short (under X minutes)? Not for MVP