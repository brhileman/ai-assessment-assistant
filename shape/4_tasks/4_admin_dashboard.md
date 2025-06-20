# Task 4: Admin Dashboard & Company Management

**Prerequisites:** Task 3 (Database Models) must be completed

## Task Overview
Create the admin dashboard and company management interface with full CRUD operations. This is the core admin experience where administrators will manage companies, view assessment progress, and oversee the entire system.

## Reference Documentation
- **User Story 2**: Company Management in `../2_user-stories/`
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
  - [x] 3.3 Add search functionality for company names
  - [x] 3.4 Add sorting by name, creation date, completion rate
  - [x] 3.5 Add pagination for large company lists
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

- [ ] 6.0 Add Stakeholder Management (Basic)
  - [ ] 6.1 Create stakeholder partial for company detail page
  - [ ] 6.2 Add "Add Stakeholder" button and modal
  - [ ] 6.3 Include stakeholder name, email, status in list
  - [ ] 6.4 Add stakeholder status badges (invited, started, completed)
  - [ ] 6.5 Show assessment completion dates
  - [ ] 6.6 Add resend invitation action
  - [ ] 6.7 Include delete stakeholder functionality

- [ ] 7.0 Create Navigation and Layout
  - [ ] 7.1 Update admin layout with proper navigation
  - [ ] 7.2 Add breadcrumb navigation for admin pages
  - [ ] 7.3 Include LaunchPad Lab branding in admin header
  - [ ] 7.4 Add admin user info and logout link
  - [ ] 7.5 Implement responsive sidebar for larger screens
  - [ ] 7.6 Test navigation works across all admin pages
  - [ ] 7.7 Add active page highlighting

- [ ] 8.0 Add Search and Filtering
  - [ ] 8.1 Implement company name search
  - [ ] 8.2 Add filter by completion status
  - [ ] 8.3 Add filter by assessment activity (recent, stale)
  - [ ] 8.4 Create filter UI components
  - [ ] 8.5 Add clear filters functionality
  - [ ] 8.6 Test search and filters work correctly
  - [ ] 8.7 Add URL parameters for shareable filtered views

- [ ] 9.0 Testing and Validation
  - [ ] 9.1 Write controller tests for all admin actions
  - [ ] 9.2 Create system tests for complete workflows
  - [ ] 9.3 Test admin authentication on all pages
  - [ ] 9.4 Verify responsive design on mobile devices
  - [ ] 9.5 Test search and filtering functionality
  - [ ] 9.6 Validate proper error handling
  - [ ] 9.7 Test accessibility compliance

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
| `app/views/admin/shared/_navigation.html.erb` | Admin navigation | 7.1 | ⏳ |
| `app/views/admin/shared/_stakeholder.html.erb` | Stakeholder list item | 6.1 | ⏳ |
| `spec/controllers/admin/dashboard_controller_spec.rb` | Dashboard tests | 9.1 | ⏳ |
| `spec/controllers/admin/companies_controller_spec.rb` | Company controller tests | 9.1 | ⏳ |
| `spec/system/admin/company_management_spec.rb` | Company workflow tests | 9.2 | ⏳ |

### Files to Modify
| File Path | Changes | Task Ref | Status |
|-----------|---------|----------|--------|
| `config/routes.rb` | Add admin namespace routes | 2.2 | ✅ |
| `app/views/layouts/admin.html.erb` | Update admin layout | 7.1 | ⏳ |

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
- [ ] Search and filtering improve usability
- [ ] Responsive design works on all devices
- [ ] Authentication protects all admin routes
- [ ] All tests pass including system tests
- [ ] UI follows design system consistently

## Next Steps

After Task 4 completion:
- Task 5: Implement SendGrid email system for stakeholder invitations
- Task 6: Create stakeholder landing pages and assessment entry flow
- The admin interface enables company setup before stakeholder invitations 