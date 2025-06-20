# User Story: Stakeholder Data Linking & Identification

**As a** system administrator  
**I want** a clear data architecture for linking invite links to stakeholders and their assessment results  
**So that** assessment data is properly attributed and organized by company and stakeholder

## Context
The system needs to track relationships between companies, stakeholders, invitation links, and assessment results. Each stakeholder must be uniquely identifiable through their invite link, and their assessment results must be properly linked back to them and their company.

## Technical Architecture

### Data Model Structure
```
Company
├── has_many stakeholders
├── name, industry, description, custom_instructions
└── created_by (admin_id)

Stakeholder  
├── belongs_to company
├── email, name, role, department (optional)
├── invitation_token (UUID)
├── invitation_sent_at
├── assessment_completed_at (optional)
└── has_one assessment

Assessment
├── belongs_to stakeholder
├── full_transcript (TEXT)
├── completed_at
└── duration (optional)
```

### Invite Link Generation Process
1. Admin creates stakeholder record with email and company association
2. System generates secure UUID token (`invitation_token`) for stakeholder
3. Invitation link format: `https://app.com/assessments/{invitation_token}`
4. No expiration date - invitation remains valid indefinitely
5. SendGrid sends personalized email with unique link

### Assessment Flow & Data Linking
1. Stakeholder clicks link with their unique token
2. System looks up stakeholder by `invitation_token`
3. System validates token exists and stakeholder hasn't completed assessment yet
4. Assessment session begins with stakeholder context loaded (including company custom instructions)
5. All conversation data is saved to Assessment record linked to stakeholder
6. Assessment completion updates stakeholder.assessment_completed_at

## Scenarios

### Happy Path
1. Admin creates stakeholder with email for specific company
2. System generates unique invitation_token (UUID)
3. Stakeholder receives email with personalized link containing their token
4. Stakeholder clicks link, system identifies them via token
5. Assessment proceeds with stakeholder context and company custom instructions
6. Conversation transcript saves to single Assessment record linked to stakeholder
7. Admin can view results organized by company → stakeholder → assessment

### Edge Cases
- **Invalid token**: Show error page with support contact
- **Already completed**: Show message that assessment is already complete with option to view results
- **Assessment in progress**: Allow stakeholder to resume incomplete assessment
- **Token security**: Prevent brute force attacks with rate limiting

## Acceptance Criteria
- [ ] UUID token generation for each stakeholder invitation
- [ ] Secure token validation on assessment access
- [ ] No token expiration - invitations remain valid indefinitely
- [ ] One-to-one relationship: Stakeholder can have only one assessment
- [ ] Prevent multiple assessments per stakeholder
- [ ] Assessment results properly linked to stakeholder and company
- [ ] Admin can filter/view results by company or stakeholder
- [ ] Prevent unauthorized access to assessment data
- [ ] Track invitation status (sent, accessed, completed)
- [ ] Company custom instructions passed to AI agent during assessment

## Security Considerations
- [ ] Use cryptographically secure UUID generation
- [ ] Rate limiting on token validation attempts
- [ ] No sensitive data in URL parameters (only opaque token)
- [ ] HTTPS required for all assessment links

## Database Indexes
- [ ] Index on stakeholders.invitation_token for fast lookup
- [ ] Index on stakeholders.company_id for admin filtering
- [ ] Index on assessments.stakeholder_id for result queries

## MVP Decisions
- **Token expiration**: No expiration - invitations remain valid indefinitely
- **Assessment limit**: One assessment per stakeholder only
- **Data tracking**: Minimal essential fields only - no audio quality metrics or version tracking
- **Custom instructions**: Company custom instructions included in stakeholder context

