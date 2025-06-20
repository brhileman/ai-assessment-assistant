# Product Requirements Document - AI Assessment Assistant

## Brief Product Overview
AI Assessment Assistant is a voice-based web application that facilitates initial interviews and surveys with clients entering LaunchPad Lab's AI assessment program. The platform enables administrators to invite company stakeholders to participate in AI-driven conversations that gather critical information about their organization's AI readiness, current technology stack, and adoption challenges.

## Objectives
1. **Streamline Client Onboarding**: Reduce initial assessment time by 70% through automated voice-based interviews
2. **Gather Comprehensive AI Readiness Data**: Collect detailed conversation transcripts about technology stack, AI adoption, and organizational readiness
3. **Enhance Client Experience**: Provide an intuitive, conversational interface that feels natural and engaging

## End Users
- **Primary User Persona**: **Company Stakeholders/Interviewees** - Business leaders, IT managers, and department heads who will participate in the AI assessment interviews. They need a simple, intuitive interface that allows them to share information naturally through voice conversation.
- **Secondary User Persona**: **LaunchPad Lab Administrators** - Internal team members who manage the assessment program, send invitations, and review collected data. They need comprehensive dashboard functionality to manage multiple companies and access interview results.

## Approach Overview
The product uses OpenAI's Realtime API to create natural, conversational interviews that gather specific business intelligence. Administrators can easily onboard new companies (with optional custom instructions for the AI agent) and invite multiple stakeholders, who receive email invitations via SendGrid with unique, non-expiring links. The voice interface displays real-time transcripts and guides conversations to collect targeted information about AI adoption, technology infrastructure, and organizational readiness. Stakeholders control when conversations start and end via clear buttons. Complete conversation transcripts are stored securely for administrator review and analysis.

## Feature List
1. **Admin Dashboard & Company Management**
   - Description: Administrative interface for creating companies (with optional custom AI agent instructions), managing invitations, and viewing completed assessments
   - Priority: High
   - Why it matters: Core functionality needed to manage the assessment program and track client progress

2. **Email Invitation System**
   - Description: Automated email invitations via SendGrid with unique, non-expiring assessment links sent to stakeholders
   - Priority: High
   - Why it matters: Essential for distributing assessments and maintaining security through unique access links

3. **Voice-Based Conversational Interface**
   - Description: OpenAI-powered voice conversation with user-controlled start/finish that guides users through assessment questions
   - Priority: High
   - Why it matters: The primary value proposition - natural, engaging way to gather detailed business information

4. **Real-Time Transcript Display**
   - Description: Live transcription of the voice conversation displayed on-screen during the interview
   - Priority: High
   - Why it matters: Provides transparency and allows users to verify accuracy of their responses

5. **Conversational Data Collection**
   - Description: AI agent trained to guide natural conversations covering role/responsibilities, metrics, tech stack, AI adoption, organizational readiness, challenges. Uses company custom instructions when provided.
   - Priority: Medium
   - Why it matters: Ensures comprehensive information gathering through natural conversation flow with company-specific focus

6. **Conversation Storage & Review**
   - Description: Secure storage of complete conversations with admin access for review and analysis (simplified for MVP - basic viewing and export)
   - Priority: High
   - Why it matters: Enables administrators to analyze responses and provide tailored AI assessment recommendations

7. **Passwordless Authentication**
   - Description: Magic link email authentication using Devise passwordless extensions with admin allowlist (manual admin account creation only)
   - Priority: Medium
   - Why it matters: Provides secure access to sensitive client data without password management overhead or public registration

8. **Microphone Permission Management**
   - Description: Browser-based microphone access request triggered after user clicks "Start Assessment"
   - Priority: High
   - Why it matters: Essential for voice functionality and user experience

## Tech Stack
- Back-end: Ruby on Rails 8 Server Rendered App
- Database: PostgreSQL (includes transcript storage)
- Authentication: Devise with passwordless extension (magic links)
- Front-end: ERB / Stimulus / Tailwind CSS / Flowbite
- Testing: Rspec
- Hosting: Heroku
- Background jobs: Sidekiq
- Emails: SendGrid
- AI Voice: OpenAI Realtime API
- Real-time: WebSockets (ActionCable) 