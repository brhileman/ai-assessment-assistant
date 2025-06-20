# User Story: Admin Authentication

**As a** LaunchPad Lab administrator  
**I want** to log in using passwordless magic link authentication via Devise  
**So that** I can securely access the admin dashboard without managing passwords

## Context
Administrators need secure but convenient access to manage client assessments and review sensitive conversation data. Using Devise with passwordless extensions provides a mature, well-tested authentication solution with magic link functionality while avoiding password management overhead.

**Admin Account Management**: Admin accounts are not publicly registrable. Only pre-approved email addresses in the admin allowlist can receive magic links and access the system.

## Scenarios

### Happy Path
1. Admin visits the login page
2. Admin enters their email address
3. System validates email is in admin allowlist
4. System generates magic link using Devise passwordless extension
5. System sends secure login link via SendGrid email delivery
6. Admin clicks the link and is automatically logged in
7. Admin is redirected to dashboard with secure session

### Edge Cases
- Invalid email: Show error message for unregistered admin emails
- Non-admin email: Show generic "email not found" message (don't reveal admin list)
- Expired link: Devise handles link expiration with friendly error message
- Link already used: Devise prevents link reuse for security
- Session expiry: Devise handles secure session management
- Email delivery issues: SendGrid provides reliable delivery and bounce handling

## Acceptance Criteria
- [ ] Email-only login form using Devise passwordless views
- [ ] Admin allowlist validation before magic link generation
- [ ] Devise passwordless gem integration (e.g., devise-passwordless)
- [ ] Magic link generation and email delivery via SendGrid
- [ ] Admin role validation before dashboard access
- [ ] Secure session management handled by Devise
- [ ] Link expiration (15 minutes) configured in Devise
- [ ] Single-use link security enforced by Devise
- [ ] SendGrid integration for reliable magic link delivery
- [ ] Generic error messages (don't reveal admin email list)

## Key Screens
- Admin login page (Devise passwordless views)
- Email sent confirmation page (Devise views)
- Admin dashboard (post-login)

## Technical Implementation
- Use Devise gem with passwordless extension (e.g., devise-passwordless)
- Configure Devise for magic link authentication
- Add admin allowlist validation before magic link generation
- Set up admin-only access with role validation
- Use default Devise passwordless views for MVP
- Configure link expiration and security settings

## MVP Decisions
- **Admin creation**: Manual database seeding/console commands for MVP
- **Rate limiting**: Not implemented for MVP - keeping authentication lightweight
- **Admin activity logging**: Not needed for MVP
- **Devise views**: Use default passwordless views initially, customize later if needed

## Admin Account Management

### Database Structure
```ruby
# Admin model or admin_emails table
class Admin < ApplicationRecord
  # email: string (unique)
  # active: boolean (default: true)
  # created_at: timestamp
  # last_login_at: timestamp (optional)
end
```

### Adding New Admins
- **Database seeding**: Add admin emails via Rails seeds or migrations
- **Rails console**: Manually add emails using `Admin.create(email: "admin@launchpadlab.com")`
- **Future enhancement**: Admin management interface for existing admins

### Security Considerations
- Only emails in admin table can receive magic links
- No public registration endpoint
- Generic error messages prevent email enumeration
- Admin list not exposed via any API 