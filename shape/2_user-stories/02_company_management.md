# User Story: Company Management

**As a** LaunchPad Lab administrator  
**I want** to create and manage client companies  
**So that** I can organize assessments by client organization and provide custom guidance to the AI agent

## Context
Administrators need to onboard new clients and manage multiple company assessment programs simultaneously. Each company may have specific focus areas or requirements that should be communicated to the AI agent during assessments.

## Scenarios

### Happy Path
1. Admin navigates to "Companies" section from dashboard
2. Admin clicks "Add New Company"
3. Admin enters company details (name, industry, description)
4. Admin optionally adds custom instructions for AI agent
5. System saves company and shows confirmation
6. Admin can view company in the companies list

### Edge Cases
- Duplicate company name: Show warning and allow confirmation
- Missing required fields: Show validation errors
- Very long custom instructions: Character limit with warning

## Acceptance Criteria
- [ ] Company creation form with required fields (name, industry, description)
- [ ] Optional custom instructions text field for AI agent guidance
- [ ] Company list view (simple list for MVP)
- [ ] Edit company details functionality
- [ ] View company assessment status/progress
- [ ] Delete company with confirmation dialog
- [ ] Custom instructions passed to AI agent during stakeholder assessments

## Key Screens
- Companies list page (simple list)
- Add/edit company form (with custom instructions field)
- Company detail/dashboard page

## Custom Instructions Feature
- **Purpose**: Provide company-specific guidance to AI agent
- **Examples**: 
  - "Focus on healthcare compliance requirements"
  - "This company is already using Salesforce AI, ask about their experience"
  - "Pay special attention to data privacy concerns in this industry"
- **Implementation**: Text area field on company form, passed to AI agent context
- **Character limit**: 500-1000 characters to keep instructions focused

## MVP Decisions
- **Search/filter**: Not implemented for MVP - simple company list is sufficient
- **Company logos**: Not needed for MVP
- **Assessment templates**: Implemented as open text custom instructions field 