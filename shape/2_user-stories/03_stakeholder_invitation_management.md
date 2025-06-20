# User Story: Stakeholder Invitation Management

**As a** LaunchPad Lab administrator  
**I want** to invite company stakeholders to participate in assessments  
**So that** I can gather comprehensive AI readiness data from multiple perspectives

## Context
Each company assessment requires input from multiple stakeholders across different roles and departments. Email invitations are sent via SendGrid to ensure reliable delivery and provide delivery tracking.

## Scenarios

### Happy Path
1. Admin selects a company from the dashboard
2. Admin navigates to "Manage Stakeholders" section
3. Admin adds stakeholder emails and optional role/department info
4. Admin clicks "Send Invitations"
5. System sends personalized email invitations via SendGrid with unique assessment links
6. Admin can track invitation status using SendGrid webhooks (sent, delivered, opened, clicked)

### Edge Cases
- Invalid email addresses: Show validation errors before sending
- Duplicate invitations: Warn admin and allow re-sending
- Email bounces: SendGrid webhooks notify system of bounce/failure status
- Bulk email failures: Show which emails failed using SendGrid delivery reports
- Spam filtering: SendGrid reputation helps ensure inbox delivery

## Acceptance Criteria
- [ ] Add multiple stakeholder emails in one session
- [ ] Custom invitation message option
- [ ] Unique assessment links generated per stakeholder
- [ ] SendGrid integration for reliable email delivery
- [ ] Email delivery status tracking via SendGrid webhooks
- [ ] Bounce and spam handling via SendGrid
- [ ] Resend invitation functionality
- [ ] View stakeholder completion status
- [ ] Professional email templates using SendGrid

## Key Screens
- Company stakeholder management page
- Invitation composition interface
- Stakeholder status dashboard with SendGrid delivery metrics

## Technical Implementation
- Integrate SendGrid API for email sending
- Configure SendGrid webhooks for delivery tracking
- Set up email templates (SendGrid templates or Rails views - whichever is easier for MVP)
- Implement bounce/spam handling logic
- Use SendGrid analytics for delivery insights

## MVP Decisions
- **Invitation expiration**: No expiration dates - invitations remain valid indefinitely
- **Reminder emails**: Not implemented for MVP - keep invitation flow simple
- **Email templates**: Use whichever approach is easier/faster to implement (SendGrid templates or Rails views) 