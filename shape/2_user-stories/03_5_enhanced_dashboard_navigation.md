# User Story: Enhanced Dashboard Navigation

**As a** LaunchPad Lab administrator  
**I want** clickable dashboard tiles and consistent page styling  
**So that** I can quickly navigate to different sections and have a cohesive admin experience

## Context
The admin dashboard currently shows overview statistics but requires admins to use the navigation menu to access detailed views. Making the dashboard tiles clickable would provide faster navigation. Additionally, some pages are missing consistent styling and layout elements.

## Scenarios

### Happy Path
1. Admin views dashboard with overview tiles (Companies, Stakeholders, Assessments)
2. Admin clicks on "Companies" tile to view all companies
3. Admin clicks on "Stakeholders" tile to view all stakeholders across all companies
4. Admin clicks on "Assessments" tile to view all completed assessments
5. All pages maintain consistent header, layout, and styling

### Edge Cases
- Empty states: Show appropriate messaging when no data exists
- Large datasets: Ensure performance remains good for list views
- Mobile responsiveness: Tiles and lists work on all screen sizes

## Acceptance Criteria
- [ ] Dashboard tiles (Companies, Stakeholders, Assessments) are clickable links
- [ ] "All Companies" list view exists and loads from dashboard tile
- [ ] "All Stakeholders" list view exists showing stakeholders across all companies
- [ ] "All Assessments" list view exists showing completed assessments across all companies
- [ ] All admin pages have consistent header with proper branding
- [ ] All admin pages have consistent gray background styling
- [ ] Assessment results page matches admin layout (header, background, navigation)
- [ ] "Add Stakeholder" page matches admin layout
- [ ] "Edit Company" page matches admin layout
- [ ] "View All Companies" page matches admin layout
- [ ] Remove "System Settings" button from dashboard (not needed for MVP)
- [ ] Clean up dashboard header text (remove redundant "AI Assessment Assistant - Admin")

## Key Screens
- Enhanced admin dashboard with clickable tiles
- All Companies list view (accessible via dashboard tile)
- All Stakeholders list view (new page, accessible via dashboard tile)
- All Assessments list view (new page, accessible via dashboard tile)
- Consistent styling across all admin pages

## Navigation Flow
```
Dashboard
├── Companies Tile → All Companies List
├── Stakeholders Tile → All Stakeholders List  
└── Assessments Tile → All Assessments List
```

## Styling Requirements
- **Consistent Header**: All admin pages should have the same header layout
- **Gray Background**: All admin pages should use the light gray background
- **Navigation**: Consistent breadcrumbs and navigation elements
- **Branding**: Proper LaunchPad Lab branding without redundant text
- **Mobile Responsive**: All layouts work across screen sizes

## MVP Decisions
- **Simple List Views**: Basic tables for stakeholder and assessment lists (no advanced filtering)
- **Basic Navigation**: Simple clickable tiles (no complex dashboard widgets)
- **Consistent Styling**: Focus on layout consistency over advanced UI features 