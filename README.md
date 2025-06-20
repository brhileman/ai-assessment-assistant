# AI Assessment Assistant

A Rails 8 application for conducting AI readiness assessments through voice-powered conversations with stakeholders.

## 🏗️ Project Structure

This repository contains both the **product documentation** and **Rails application** in a unified structure:

```
ai-assessment-assistant/
├── shape/                          # 📋 Product Documentation
│   ├── 1_big-picture/             # PRD and system flowchart
│   ├── 2_user-stories/            # User stories with acceptance criteria
│   ├── 3_design-system/           # UI/UX standards and mockups
│   └── 4_tasks/                   # Implementation tasks with progress
├── app/                           # 🚀 Rails Application
│   ├── controllers/               # Controllers (admin, pages, auth)
│   ├── models/                    # Data models (Admin, etc.)
│   ├── views/                     # ERB templates with Tailwind CSS
│   └── assets/                    # Stylesheets, images, JavaScript
├── spec/                          # 🧪 Tests (RSpec, Capybara)
├── config/                        # ⚙️ Rails configuration
└── db/                           # 🗄️ Database migrations and schema
```

## ✅ **Completed Features**

### **Task 1: Rails Application Foundation** ✅
- ✅ Rails 8.0.2 with PostgreSQL database
- ✅ Tailwind CSS styling with responsive design
- ✅ LaunchPad Lab branding and welcome page
- ✅ RSpec testing framework with system tests
- ✅ Flowbite UI components integration

### **Task 2: Admin Authentication System** ✅
- ✅ Devise authentication with Admin model
- ✅ Magic link login system (passwordless)
- ✅ Admin allowlist security system
- ✅ Protected admin dashboard
- ✅ Beautiful login pages with LaunchPad Lab branding
- ✅ System tests for complete authentication flow

## 🚀 **Getting Started**

### Prerequisites
- Ruby 3.2.2
- Rails 8.0.2
- PostgreSQL
- Node.js (for asset compilation)

### Setup
```bash
# Clone the repository
git clone <repository-url>
cd ai-assessment-assistant

# Install dependencies
bundle install

# Setup database
rails db:create db:migrate db:seed

# Start the development server
bin/dev
```

### Access Points
- **Main Site**: http://localhost:3000
- **Admin Login**: http://localhost:3000/admins/magic_link/new
- **Admin Dashboard**: http://localhost:3000/admin (requires authentication)

### Admin Access
Admin accounts are managed through an allowlist system. Default admin emails:
- `admin@launchpadlab.com`
- `assessment@launchpadlab.com`

## 🧪 **Testing**

```bash
# Run all tests
bundle exec rspec

# Run system tests specifically
bundle exec rspec spec/system

# Run with coverage
COVERAGE=true bundle exec rspec
```

## 📋 **Development Workflow**

This project follows a structured development process:

1. **📋 Shape Phase**: Define requirements in `shape/` documentation
2. **🚀 Implementation**: Build features following task specifications
3. **✅ Testing**: Write comprehensive tests for all functionality
4. **🔄 Iteration**: Update documentation as features evolve

### Current Status
- ✅ **Task 1 & 2**: Complete (Application foundation + Admin auth)
- 🔄 **Task 3**: Ready to start (Database models for companies/stakeholders)
- ⏳ **Tasks 4-7**: Planned (Dashboard, email system, voice assessments)

## 🏢 **About**

**AI Assessment Assistant** helps organizations evaluate their AI readiness through:
- 🎙️ **Voice Assessments**: Natural conversation-based evaluations
- 👥 **Stakeholder Management**: Multi-role assessment coordination  
- 📊 **Real-time Insights**: Live transcripts and progress tracking
- 🔒 **Enterprise Security**: Secure data handling and access controls

Built with modern Rails patterns, comprehensive testing, and LaunchPad Lab's proven development methodologies.

---

**LaunchPad Lab** | [Website](https://launchpadlab.com) | [Email](mailto:assessment@launchpadlab.com) 