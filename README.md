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
├── code/ai_assessment_assistant/   # 🚀 Rails Application
│   ├── app/
│   │   ├── controllers/           # Admin, voice, API controllers
│   │   ├── models/                # Company, Stakeholder, Assessment, Admin
│   │   ├── views/                 # ERB templates with Tailwind CSS
│   │   ├── services/              # OpenAI integration services
│   │   └── assets/                # Stylesheets, images, JavaScript
│   ├── spec/                      # 🧪 Tests (RSpec, Capybara)
│   ├── config/                    # ⚙️ Rails configuration
│   └── db/                        # 🗄️ Database migrations and schema
└── bin/                           # 🎯 Wrapper scripts (see below)
```

## ✅ **Completed Features**

### **Phase 1: Foundation** ✅
**Task 1: Rails Application Foundation** ✅
- ✅ Rails 8.0.2 with PostgreSQL database
- ✅ Tailwind CSS styling with responsive design
- ✅ LaunchPad Lab branding and welcome page
- ✅ RSpec testing framework with system tests
- ✅ Flowbite UI components integration

**Task 2: Admin Authentication System** ✅
- ✅ Devise passwordless authentication with magic links
- ✅ Admin allowlist security system
- ✅ Protected admin dashboard with proper routing
- ✅ Beautiful login pages with LaunchPad Lab branding
- ✅ System tests for complete authentication flow

### **Phase 2: Core Data & Management** ✅
**Task 3: Database Models & Architecture** ✅
- ✅ Company model with custom AI instructions
- ✅ Stakeholder model with UUID invitation tokens
- ✅ Assessment model with transcript storage
- ✅ Proper relationships and validations
- ✅ Database indexes and constraints
- ✅ Comprehensive seed data for development

**Task 4: Admin Dashboard & Company Management** ✅
- ✅ Complete admin dashboard with real-time statistics
- ✅ Company CRUD operations (create, read, update, delete)
- ✅ Stakeholder management within companies
- ✅ Assessment progress tracking and visualization
- ✅ Recent activity feeds and completion rates
- ✅ Responsive design with LaunchPad Lab styling

### **Phase 3: Stakeholder Experience** 🔄
**Task 5: Email Invitation System** ✅
- ✅ SendGrid email integration with templates
- ✅ Automated stakeholder invitation emails
- ✅ Assessment completion thank you emails
- ✅ Email template design with branding

**Task 6: Stakeholder Landing Pages** ✅
- ✅ Token-based assessment access (no login required)
- ✅ Company-branded assessment start pages
- ✅ Assessment completion confirmation pages
- ✅ Error handling for invalid/expired tokens

**Task 7: Voice Assessment Interface** 🔄
- ✅ Modern voice assessment UI with dark glassmorphism theme
- ✅ OpenAI Realtime API integration for voice conversations
- ✅ Real-time transcript display during conversations
- ✅ Company-specific AI agent instructions
- ⏳ Complete voice flow optimization

## 🚀 **Getting Started**

### Prerequisites
- Ruby 3.2.2
- Rails 8.0.2
- PostgreSQL 14+
- Node.js (for asset compilation)

### 🎯 **Rails Command Wrapper Scripts**

**Important:** The Rails application is located in `code/ai_assessment_assistant/`. To prevent directory confusion, wrapper scripts are provided at the project root:

```bash
# ✅ Use these from the project root (they automatically delegate):
bin/rails server              # Starts the Rails server
bin/rails console             # Opens Rails console  
bin/rails db:migrate          # Runs database migrations
bin/dev                       # Starts development server with all processes
bin/bundle install            # Installs gems

# ❌ Don't manually cd to nested directories
```

**Benefits:**
- 🚫 **Prevents "bin/rails: No such file"** errors
- 📍 **Clear feedback** about which directory commands run in  
- 🔄 **Consistent workflow** regardless of current directory

See `bin/README.md` for complete documentation of wrapper scripts.

### Setup
```bash
# Clone the repository
git clone <repository-url>
cd ai-assessment-assistant

# Install dependencies
bin/bundle install

# Setup database
bin/rails db:create db:migrate db:seed

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
- `bretthilema@gmail.com`

### Development Data
The seed file creates realistic development data:
- **8 companies** with stakeholders
- **38 stakeholders** with various statuses
- **10 assessments** (5 completed, 5 in progress)

## 🧪 **Testing**

```bash
# Run all tests
bin/bundle exec rspec

# Run system tests specifically
bin/bundle exec rspec spec/system

# Run with coverage
COVERAGE=true bin/bundle exec rspec
```

## 🚀 **Deployment & Production**

### **Production Environment**
- **Platform**: Hosted on Heroku
- **App Name**: `ai-assessment-assistant`
- **Production URL**: https://ai-assessment-assistant-9e4a484c0b2f.herokuapp.com/
- **Git Remote**: `heroku` (https://git.heroku.com/ai-assessment-assistant.git)

### **Deployment Process**
```bash
# Deploy to Heroku (from main branch)
git push heroku main

# Run migrations on Heroku
heroku run rails db:migrate

# Check production logs
heroku logs --tail

# Open production app
heroku open
```

### **Environment Variables**
Required production environment variables on Heroku:
- `OPENAI_API_KEY` - OpenAI API key for voice assessments
- `OPENAI_ORGANIZATION_ID` - OpenAI organization ID
- `SENDGRID_API_KEY` - SendGrid API key for email delivery
- `DATABASE_URL` - Automatically set by Heroku
- `RAILS_MASTER_KEY` - For Rails encrypted credentials

### **Heroku Configuration**
- **Stack**: Heroku-24
- **Buildpacks**: 
  1. `heroku-buildpack-monorepo` (for nested Rails app structure)
  2. `heroku/ruby`
- **Add-ons**: 
  - Heroku Postgres (database)
  - Heroku Redis (for caching/ActionCable)

### **Important Notes for Future Development**
- The Rails app is nested in `code/ai_assessment_assistant/` directory
- Heroku uses the monorepo buildpack to handle this structure
- All deployments should be done from the main branch
- Database migrations run automatically via release phase (see `Procfile`)

## 📊 **Current Features Overview**

### **For Administrators**
- 🔐 **Secure Login**: Magic link authentication system
- 🏢 **Company Management**: Full CRUD operations with custom AI instructions
- 👥 **Stakeholder Management**: Add stakeholders, track assessment progress
- 📈 **Dashboard Analytics**: Real-time completion rates, activity feeds
- 📧 **Email Management**: Automated invitations and follow-ups

### **For Stakeholders**
- 📧 **Email Invitations**: Receive branded assessment invitations
- 🔗 **Token Access**: Secure, no-login assessment access
- 🎙️ **Voice Assessments**: Natural AI conversations about AI readiness
- 📝 **Real-time Transcripts**: See conversation as it happens
- ✅ **Completion Confirmation**: Thank you pages with next steps

### **Technical Features**
- 🚀 **Rails 8.0.2**: Latest Rails with modern patterns
- 🗄️ **PostgreSQL**: Robust data storage with proper indexing
- 🎨 **Tailwind CSS**: Responsive, modern UI design
- 🔊 **OpenAI Realtime API**: Advanced voice conversation capabilities
- 📧 **SendGrid Integration**: Reliable email delivery
- 🧪 **Comprehensive Testing**: RSpec unit and system tests
- 🛡️ **Security**: Token-based access, admin allowlists

## 📋 **Development Workflow**

This project follows a structured development process:

1. **📋 Shape Phase**: Define requirements in `shape/` documentation
2. **🚀 Implementation**: Build features following task specifications
3. **✅ Testing**: Write comprehensive tests for all functionality
4. **🔄 Iteration**: Update documentation as features evolve

### Current Status
- ✅ **Tasks 1-6**: Complete (Foundation → Stakeholder Experience)
- 🔄 **Task 7**: Voice assessment optimization in progress
- ⏳ **Tasks 8-9**: Production deployment and results management planned

## 🏢 **About**

**AI Assessment Assistant** helps organizations evaluate their AI readiness through:
- 🎙️ **Voice Assessments**: Natural conversation-based evaluations with AI agents
- 👥 **Stakeholder Management**: Multi-role assessment coordination across organizations
- 📊 **Real-time Insights**: Live transcripts and progress tracking during assessments
- 🔒 **Enterprise Security**: Secure data handling, token-based access controls
- 📧 **Automated Communications**: Branded email invitations and follow-ups
- 📈 **Admin Analytics**: Completion tracking and company-level insights

Built with modern Rails patterns, comprehensive testing, and LaunchPad Lab's proven development methodologies.

---

**LaunchPad Lab** | [Website](https://launchpadlab.com) | [Email](mailto:assessment@launchpadlab.com) 