# Task 4: Admin Dashboard & Company Management

**Prerequisites:** Task 3 (Database Models) must be completed

## Task Overview
Create the admin dashboard and company management interface with full CRUD operations. This is the core admin experience where administrators will manage companies, view assessment progress, and oversee the entire system.

## Reference Documentation
- **User Story 2**: Company Management in `../2_user-stories/`
- **User Story 9**: Assessment Results Review in `../2_user-stories/09_assessment_results_review.md`
- **Design System**: Light theme for admin pages in `../3_design-system/`
- **Data Models**: Company, Stakeholder, Assessment models from Task 3

## Implementation Strategy
**Start with the core admin dashboard first** - build this completely and get user approval before proceeding to detailed CRUD operations.

## Tasks

- [x] 1.0 Create Admin Dashboard (Core Experience)
  - [x] 1.1 Generate Admin::DashboardController: `rails generate controller Admin::Dashboard index`
  - [x] 1.2 Create admin dashboard layout using light theme design system
  - [x] 1.3 Add overview cards: total companies, assessments completed, pending assessments
  - [x] 1.4 Create recent activity feed showing latest assessment completions
  - [x] 1.5 Add quick stats visualization (completion rates, response times)
  - [x] 1.6 Test dashboard loads properly at `/admin`
  - [x] 1.7 **STOP HERE - Let user review dashboard experience**

- [x] 2.0 Create Companies Controller and Routes
  - [x] 2.1 Generate Admin::CompaniesController: `rails generate controller Admin::Companies index show new create edit update destroy`
  - [x] 2.2 Set up RESTful routes under admin namespace
  - [x] 2.3 Add before_action authentication filters
  - [x] 2.4 Implement strong parameters for company attributes
  - [x] 2.5 Add success/error flash messages
  - [x] 2.6 Test all routes are accessible to authenticated admins

- [x] 3.0 Implement Company Index (List View)
  - [x] 3.1 Create companies index page with responsive table
  - [x] 3.2 Display company name, stakeholder count, completion rate
  - [~] 3.3 Add search functionality for company names *(DEFERRED for MVP - simple list sufficient)*
  - [~] 3.4 Add sorting by name, creation date, completion rate *(DEFERRED for MVP - simple list sufficient)*
  - [~] 3.5 Add pagination for large company lists *(DEFERRED for MVP - simple list sufficient)*
  - [x] 3.6 Include action buttons (view, edit, delete)
  - [x] 3.7 Style using design system light theme

- [x] 4.0 Create Company Detail View
  - [x] 4.1 Create company show page with overview section
  - [x] 4.2 Display company information and custom instructions
  - [x] 4.3 Show stakeholder list with assessment status
  - [x] 4.4 Add assessment completion progress bar
  - [x] 4.5 Include recent assessment activity
  - [x] 4.6 Add quick actions (add stakeholder, edit company)
  - [x] 4.7 Test stakeholder status updates correctly

- [x] 5.0 Implement Company Forms (New/Edit)
  - [x] 5.1 Create new company form with name and custom instructions
  - [x] 5.2 Add form validation and error handling
  - [x] 5.3 Create edit company form (same fields as new)
  - [x] 5.4 Add rich text editor for custom instructions
  - [x] 5.5 Include helpful instructions for AI agent customization
  - [x] 5.6 Test form submissions and validations
  - [x] 5.7 Add cancel/save actions with proper redirects

- [x] 6.0 Add Stakeholder Management (Basic)
  - [x] 6.1 Create stakeholder partial for company detail page
  - [x] 6.2 Add "Add Stakeholder" button and modal
  - [x] 6.3 Include stakeholder name, email, status in list
  - [x] 6.4 Add stakeholder status badges (invited, started, completed)
  - [x] 6.5 Show assessment completion dates
  - [x] 6.6 Add resend invitation action
  - [x] 6.7 Include delete stakeholder functionality

- [ ] 7.0 Create Navigation and Layout
  - [ ] 7.1 Update admin layout with proper navigation
  - [ ] 7.2 Add breadcrumb navigation for admin pages
  - [ ] 7.3 Include LaunchPad Lab branding in admin header
  - [ ] 7.4 Add admin user info and logout link
  - [ ] 7.5 Implement responsive sidebar for larger screens
  - [ ] 7.6 Test navigation works across all admin pages
  - [ ] 7.7 Add active page highlighting

- [ ] 7.5 Enhanced Dashboard Navigation & UI Cleanup
  - [ ] 7.5.1 Make dashboard tiles clickable (Companies, Stakeholders, Assessments)
  - [ ] 7.5.2 Create "All Stakeholders" list view accessible from dashboard tile
  - [ ] 7.5.3 Create "All Assessments" list view accessible from dashboard tile
  - [ ] 7.5.4 Remove "System Settings" button from dashboard (not needed for MVP)
  - [ ] 7.5.5 Clean up dashboard header text (remove redundant "AI Assessment Assistant - Admin")
  - [ ] 7.5.6 Fix "Show full instructions" functionality in company view (expand/collapse)
  - [ ] 7.5.7 Ensure assessment results page has consistent admin layout (header, gray background)
  - [ ] 7.5.8 Ensure "Add Stakeholder" page has consistent admin layout
  - [ ] 7.5.9 Ensure "Edit Company" page has consistent admin layout
  - [ ] 7.5.10 Ensure "View All Companies" page has consistent admin layout
  - [ ] 7.5.11 Test all clickable tiles navigate correctly
  - [ ] 7.5.12 Add CSV export functionality to company assessment results

- [~] 8.0 Add Search and Filtering *(DEFERRED for MVP)*
  - [~] 8.1 Implement company name search *(Not needed for MVP - simple list sufficient)*
  - [~] 8.2 Add filter by completion status *(Not needed for MVP - simple list sufficient)*
  - [~] 8.3 Add filter by assessment activity (recent, stale) *(Not needed for MVP - simple list sufficient)*
  - [~] 8.4 Create filter UI components *(Not needed for MVP - simple list sufficient)*
  - [~] 8.5 Add clear filters functionality *(Not needed for MVP - simple list sufficient)*
  - [~] 8.6 Test search and filters work correctly *(Not needed for MVP - simple list sufficient)*
  - [~] 8.7 Add URL parameters for shareable filtered views *(Not needed for MVP - simple list sufficient)*

- [x] 8.0 Assessment Results Review (Individual Transcript Viewing)
  - [x] 8.1 Generate Admin::AssessmentsController: `rails generate controller Admin::Assessments show`
  - [x] 8.2 Add assessment results routes under companies namespace
  - [x] 8.3 Create assessment show page with full transcript display
  - [x] 8.4 Add transcript formatting with timestamps (if available)
  - [x] 8.5 Display assessment metadata (duration, completion date, stakeholder info)
  - [x] 8.6 Add navigation back to company dashboard
  - [x] 8.7 Update "View" links in company dashboard to work properly
  - [x] 8.8 Update main dashboard Recent Activity feed with clickable assessment links
  - [x] 8.9 Ensure consistent linking from both dashboard and company views
  - [x] 8.10 Handle edge cases (incomplete assessments, missing transcripts)
  - [x] 8.11 Style assessment results page using design system
  - [x] 8.12 Test assessment viewing works from all entry points (dashboard + company view)

- [~] 9.0 Add Search and Filtering *(DEFERRED for MVP)*
  - [~] 9.1 Implement company name search *(Not needed for MVP - simple list sufficient)*
  - [~] 9.2 Add filter by completion status *(Not needed for MVP - simple list sufficient)*
  - [~] 9.3 Add filter by assessment activity (recent, stale) *(Not needed for MVP - simple list sufficient)*
  - [~] 9.4 Create filter UI components *(Not needed for MVP - simple list sufficient)*
  - [~] 9.5 Add clear filters functionality *(Not needed for MVP - simple list sufficient)*
  - [~] 9.6 Test search and filters work correctly *(Not needed for MVP - simple list sufficient)*
  - [~] 9.7 Add URL parameters for shareable filtered views *(Not needed for MVP - simple list sufficient)*

- [ ] 10.0 Testing and Validation
  - [ ] 10.1 Write controller tests for all admin actions
  - [ ] 10.2 Create system tests for complete workflows
  - [ ] 10.3 Test admin authentication on all pages
  - [ ] 10.4 Verify responsive design on mobile devices
  - [~] 10.5 Test search and filtering functionality *(DEFERRED for MVP - simple list sufficient)*
  - [ ] 10.6 Validate proper error handling
  - [ ] 10.7 Test accessibility compliance
  - [ ] 10.8 Test assessment results viewing workflow

## File Tracking

### Files to Create
| File Path | Purpose | Task Ref | Status |
|-----------|---------|----------|--------|
| `app/controllers/admin/dashboard_controller.rb` | Admin dashboard controller | 1.1 | ✅ |
| `app/views/admin/dashboard/index.html.erb` | Dashboard view | 1.2 | ✅ |
| `app/controllers/admin/companies_controller.rb` | Company CRUD controller | 2.1 | ✅ |
| `app/views/admin/companies/index.html.erb` | Companies list view | 3.1 | ✅ |
| `app/views/admin/companies/show.html.erb` | Company detail view | 4.1 | ✅ |
| `app/views/admin/companies/new.html.erb` | New company form | 5.1 | ✅ |
| `app/views/admin/companies/edit.html.erb` | Edit company form | 5.3 | ✅ |
| `app/views/admin/companies/_form.html.erb` | Company form partial | 5.1 | ✅ |
| `app/controllers/admin/stakeholders_controller.rb` | Stakeholder CRUD controller | 6.0 | ✅ |
| `app/views/admin/stakeholders/new.html.erb` | New stakeholder form | 6.2 | ✅ |
| `app/views/admin/stakeholders/index.html.erb` | All stakeholders list view | 7.5.2 | ⏳ |
| `app/controllers/admin/assessments_controller.rb` | Assessment results controller | 8.1 | ✅ |
| `app/views/admin/assessments/show.html.erb` | Individual assessment transcript view | 8.3 | ✅ |
| `app/views/admin/assessments/index.html.erb` | All assessments list view | 7.5.3 | ⏳ |
| `app/views/admin/shared/_navigation.html.erb` | Admin navigation | 7.1 | ⏳ |
| `app/views/admin/shared/_stakeholder.html.erb` | Stakeholder list item | 6.1 | ✅ |
| `spec/controllers/admin/dashboard_controller_spec.rb` | Dashboard tests | 10.1 | ⏳ |
| `spec/controllers/admin/companies_controller_spec.rb` | Company controller tests | 10.1 | ⏳ |
| `spec/controllers/admin/assessments_controller_spec.rb` | Assessment results controller tests | 10.1 | ⏳ |
| `spec/requests/admin/stakeholders_spec.rb` | Stakeholder controller tests | 6.0 | ✅ |
| `spec/system/admin/company_management_spec.rb` | Company workflow tests | 10.2 | ⏳ |
| `spec/system/admin/assessment_results_spec.rb` | Assessment viewing workflow tests | 10.8 | ⏳ |

### Files to Modify
| File Path | Changes | Task Ref | Status |
|-----------|---------|----------|--------|
| `config/routes.rb` | Add admin namespace routes | 2.2 | ✅ |
| `config/routes.rb` | Add assessment results routes | 8.2 | ✅ |
| `config/routes.rb` | Add stakeholder index and assessment index routes | 7.5.2, 7.5.3 | ⏳ |
| `app/views/layouts/admin.html.erb` | Update admin layout | 7.1 | ⏳ |
| `app/views/admin/companies/show.html.erb` | Update "View" links to work properly | 8.7 | ✅ |
| `app/views/admin/companies/show.html.erb` | Fix "Show full instructions" functionality | 7.5.6 | ⏳ |
| `app/views/admin/companies/show.html.erb` | Add CSV export functionality | 7.5.12 | ⏳ |
| `app/views/admin/dashboard/index.html.erb` | Add clickable links to Recent Activity feed | 8.8 | ✅ |
| `app/views/admin/dashboard/index.html.erb` | Make dashboard tiles clickable | 7.5.1 | ⏳ |
| `app/views/admin/dashboard/index.html.erb` | Remove system settings button | 7.5.4 | ⏳ |
| `app/views/admin/dashboard/index.html.erb` | Clean up header text | 7.5.5 | ⏳ |
| `app/controllers/admin/stakeholders_controller.rb` | Add index action for all stakeholders view | 7.5.2 | ⏳ |
| `app/controllers/admin/assessments_controller.rb` | Add index action for all assessments view | 7.5.3 | ⏳ |
| `app/controllers/admin/companies_controller.rb` | Add CSV export action | 7.5.12 | ⏳ |

## Dashboard Overview Mockup

```erb
<!-- Admin Dashboard Layout -->
<div class="admin-dashboard">
  <!-- Stats Cards -->
  <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
    <div class="stats-card">
      <h3>Total Companies</h3>
      <p class="text-3xl font-bold text-lpl-blue"><%= @total_companies %></p>
    </div>
    <div class="stats-card">
      <h3>Assessments Completed</h3>
      <p class="text-3xl font-bold text-green-600"><%= @completed_assessments %></p>
    </div>
    <div class="stats-card">
      <h3>Pending Assessments</h3>
      <p class="text-3xl font-bold text-orange-500"><%= @pending_assessments %></p>
    </div>
  </div>
  
  <!-- Recent Activity -->
  <div class="recent-activity">
    <h2>Recent Assessment Activity</h2>
    <!-- List of recent completions -->
  </div>
  
  <!-- Quick Actions -->
  <div class="quick-actions">
    <%= link_to "Add New Company", new_admin_company_path, class: "btn btn-primary" %>
    <%= link_to "View All Companies", admin_companies_path, class: "btn btn-secondary" %>
  </div>
</div>
```

## Success Criteria

- [ ] Admin dashboard provides clear overview of system status
- [ ] Company CRUD operations work flawlessly
- [ ] Stakeholder management integrates seamlessly
- [ ] Assessment results viewing displays full transcripts with metadata
- [ ] Individual assessment pages accessible from multiple entry points:
  - [ ] Company dashboard "View" links
  - [ ] Main dashboard Recent Activity feed links
- [~] Search and filtering improve usability *(DEFERRED for MVP - simple list sufficient)*
- [ ] Responsive design works on all devices
- [ ] Authentication protects all admin routes
- [ ] All tests pass including system tests
- [ ] UI follows design system consistently

## Next Steps

After Task 4 completion:
- Task 5: Implement SendGrid email system for stakeholder invitations
- Task 6: Create stakeholder landing pages and assessment entry flow
- The admin interface enables company setup before stakeholder invitations 