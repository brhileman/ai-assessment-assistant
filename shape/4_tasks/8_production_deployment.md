# Task 8: Production Deployment to Heroku

**Prerequisites:** Task 7 (Voice Assessment Interface) must be completed

## Task Overview
Deploy the AI Assessment Assistant application to production on Heroku with full production services including PostgreSQL database, SendGrid email delivery, secure environment configuration, and monitoring. Transform the local development application into a robust, scalable production system.

## Reference Documentation
- **User Story 10**: System Performance in `../2_user-stories/`
- **User Story 11**: Data Security in `../2_user-stories/`
- **Heroku Documentation**: https://devcenter.heroku.com/
- **SendGrid Rails Integration**: https://docs.sendgrid.com/for-developers/sending-email/rubyonrails

## Tasks

- [ ] 1.0 Production Environment Setup
  - [ ] 1.1 Create Heroku application: `heroku create ai-assessment-assistant`
  - [ ] 1.2 Set up production Git remote: `heroku git:remote -a ai-assessment-assistant`
  - [ ] 1.3 Configure Heroku Stack (heroku-22 or heroku-24)
  - [ ] 1.4 Set up production environment variables
  - [ ] 1.5 Configure Rails production environment settings
  - [ ] 1.6 Test Heroku CLI connectivity and authentication

- [ ] 2.0 Database Configuration
  - [ ] 2.1 Add Heroku PostgreSQL addon: `heroku addons:create heroku-postgresql:mini`
  - [ ] 2.2 Configure database.yml for production PostgreSQL
  - [ ] 2.3 Set up database migrations for production deployment
  - [ ] 2.4 Configure database connection pooling and timeouts
  - [ ] 2.5 Set up database backup strategy
  - [ ] 2.6 Test database connectivity and performance

- [ ] 3.0 Email Service Integration (SendGrid)
  - [ ] 3.1 Create SendGrid account and API key
  - [ ] 3.2 Add SendGrid addon to Heroku: `heroku addons:create sendgrid:starter`
  - [ ] 3.3 Configure Action Mailer for SendGrid SMTP
  - [ ] 3.4 Set up email templates for production branding
  - [ ] 3.5 Configure email authentication (SPF, DKIM)
  - [ ] 3.6 Set up email monitoring and deliverability tracking
  - [ ] 3.7 Test email delivery in production environment

- [ ] 4.0 Environment Variables and Secrets Management
  - [ ] 4.1 Configure OpenAI API key: `heroku config:set OPENAI_API_KEY=xxx`
  - [ ] 4.2 Set up Rails master key: `heroku config:set RAILS_MASTER_KEY=xxx`
  - [ ] 4.3 Configure SendGrid credentials
  - [ ] 4.4 Set production domain and host configuration
  - [ ] 4.5 Configure Devise secret keys and pepper
  - [ ] 4.6 Set up asset host for CDN (if needed)
  - [ ] 4.7 Verify all environment variables are properly set

- [ ] 5.0 Production Security Configuration
  - [ ] 5.1 Enable force_ssl in production environment
  - [ ] 5.2 Configure Content Security Policy (CSP) headers
  - [ ] 5.3 Set up secure session and cookie configuration
  - [ ] 5.4 Configure CORS settings for API endpoints
  - [ ] 5.5 Enable HSTS (HTTP Strict Transport Security)
  - [ ] 5.6 Set up rate limiting for API endpoints
  - [ ] 5.7 Configure security headers middleware

- [ ] 6.0 Asset Management and Performance
  - [ ] 6.1 Configure asset precompilation for production
  - [ ] 6.2 Set up asset CDN (CloudFront or similar)
  - [ ] 6.3 Enable gzip compression for assets
  - [ ] 6.4 Configure cache headers for static assets
  - [ ] 6.5 Optimize image assets and add compression
  - [ ] 6.6 Set up browser caching strategies
  - [ ] 6.7 Test asset loading performance

- [ ] 7.0 Application Deployment Process
  - [ ] 7.1 Create Procfile for Heroku process types
  - [ ] 7.2 Configure buildpacks (Ruby, Node.js if needed)
  - [ ] 7.3 Set up pre-deployment hooks (asset compilation)
  - [ ] 7.4 Configure post-deployment tasks (migrations)
  - [ ] 7.5 Deploy application: `git push heroku main`
  - [ ] 7.6 Run database migrations: `heroku run rails db:migrate`
  - [ ] 7.7 Verify successful deployment and application startup

- [ ] 8.0 Production Monitoring and Logging
  - [ ] 8.1 Set up Heroku log aggregation
  - [ ] 8.2 Configure application performance monitoring (APM)
  - [ ] 8.3 Set up error tracking (Sentry or Bugsnag)
  - [ ] 8.4 Configure health check endpoints
  - [ ] 8.5 Set up uptime monitoring (Pingdom or similar)
  - [ ] 8.6 Configure alert notifications for critical issues
  - [ ] 8.7 Test monitoring and alerting systems

- [ ] 9.0 Domain and SSL Configuration
  - [ ] 9.1 Configure custom domain (if applicable)
  - [ ] 9.2 Set up SSL certificate (Heroku SSL or custom)
  - [ ] 9.3 Configure DNS settings for custom domain
  - [ ] 9.4 Set up domain redirects (www to non-www or vice versa)
  - [ ] 9.5 Update CORS and CSP policies for production domain
  - [ ] 9.6 Configure subdomain routing if needed
  - [ ] 9.7 Test SSL certificate and domain configuration

- [ ] 10.0 Production Testing and Validation
  - [ ] 10.1 Test admin authentication and magic link emails
  - [ ] 10.2 Verify company and stakeholder management functions
  - [ ] 10.3 Test complete voice assessment flow end-to-end
  - [ ] 10.4 Validate email invitation and notification system
  - [ ] 10.5 Test performance under simulated load
  - [ ] 10.6 Verify data security and privacy compliance
  - [ ] 10.7 Conduct final security scan and penetration testing

- [ ] 11.0 Backup and Disaster Recovery
  - [ ] 11.1 Configure automated database backups
  - [ ] 11.2 Set up backup retention and cleanup policies
  - [ ] 11.3 Document database restoration procedures
  - [ ] 11.4 Create application deployment rollback strategy
  - [ ] 11.5 Set up monitoring for backup success/failure
  - [ ] 11.6 Test backup restoration process
  - [ ] 11.7 Document disaster recovery procedures

- [ ] 12.0 Documentation and Handoff
  - [ ] 12.1 Create production deployment documentation
  - [ ] 12.2 Document environment variable configuration
  - [ ] 12.3 Create troubleshooting guide for common issues
  - [ ] 12.4 Document monitoring and alerting setup
  - [ ] 12.5 Create admin user management procedures
  - [ ] 12.6 Document backup and recovery procedures
  - [ ] 12.7 Prepare production support and maintenance guide

## Implementation Details

### Heroku Configuration Files

#### Procfile
```
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -e production
release: bundle exec rails db:migrate
```

#### Production Environment Configuration
```ruby
# config/environments/production.rb
Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.assets.compile = false
  config.active_storage.variant_processor = :mini_magick
  
  # Force all access to the app over SSL
  config.force_ssl = true
  
  # Use a different logger for distributed setups
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  
  # Action Mailer configuration for SendGrid
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD'],
    domain: ENV['HEROKU_APP_NAME'] + '.herokuapp.com',
    address: 'smtp.sendgrid.net',
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }
  
  config.action_mailer.default_url_options = { 
    host: ENV['HEROKU_APP_NAME'] + '.herokuapp.com',
    protocol: 'https'
  }
end
```

### Environment Variables Setup Script
```bash
#!/bin/bash
# Set up production environment variables

# Rails configuration
heroku config:set RAILS_ENV=production
heroku config:set RACK_ENV=production
heroku config:set RAILS_SERVE_STATIC_FILES=enabled
heroku config:set RAILS_LOG_TO_STDOUT=enabled

# Rails secrets (generate with: rails secret)
heroku config:set SECRET_KEY_BASE=$(rails secret)
heroku config:set RAILS_MASTER_KEY=$(cat config/master.key)

# OpenAI configuration
heroku config:set OPENAI_API_KEY=your_openai_api_key_here

# Application configuration
heroku config:set APP_DOMAIN=your-app-name.herokuapp.com
heroku config:set HEROKU_APP_NAME=your-app-name

# Email configuration (automatically set by SendGrid addon)
# SENDGRID_USERNAME and SENDGRID_PASSWORD will be set automatically
```

### Database Configuration
```yaml
# config/database.yml
production:
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000
  url: <%= ENV['DATABASE_URL'] %>
  prepared_statements: false
```

### Security Headers Middleware
```ruby
# config/application.rb
class Application < Rails::Application
  # Security headers
  config.force_ssl = true
  
  config.middleware.use Rack::Attack
  
  # Content Security Policy
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self, :https
    policy.style_src   :self, :https, :unsafe_inline
    policy.connect_src :self, :https, "wss:"
  end
end
```

## File Tracking

### Files to Create
| File Path | Purpose | Task Ref | Status |
|-----------|---------|----------|--------|
| `Procfile` | Heroku process types | 7.1 | ⏳ |
| `config/environments/production.rb` | Production configuration | 1.5 | ⏳ |
| `config/initializers/sendgrid.rb` | SendGrid configuration | 3.3 | ⏳ |
| `config/initializers/security.rb` | Security headers | 5.2 | ⏳ |
| `config/initializers/rack_attack.rb` | Rate limiting | 5.6 | ⏳ |
| `lib/tasks/heroku.rake` | Deployment tasks | 7.4 | ⏳ |
| `docs/production_deployment.md` | Deployment guide | 12.1 | ⏳ |
| `docs/production_troubleshooting.md` | Troubleshooting guide | 12.3 | ⏳ |
| `docs/backup_procedures.md` | Backup documentation | 12.6 | ⏳ |

### Files to Modify
| File Path | Changes | Task Ref | Status |
|-----------|---------|----------|--------|
| `config/database.yml` | Add production database config | 2.2 | ⏳ |
| `config/application.rb` | Add security middleware | 5.2 | ⏳ |
| `config/routes.rb` | Add health check routes | 8.4 | ⏳ |
| `Gemfile` | Add production gems | 1.4 | ⏳ |
| `app/controllers/application_controller.rb` | Add security headers | 5.1 | ⏳ |

## Heroku Addons and Services

### Essential Addons
```bash
# Database
heroku addons:create heroku-postgresql:mini

# Email delivery
heroku addons:create sendgrid:starter

# Redis for caching/sessions (if needed)
heroku addons:create heroku-redis:mini

# Error tracking
heroku addons:create sentry:f1

# Performance monitoring
heroku addons:create newrelic:wayne

# SSL certificate (automatic for paid plans)
heroku addons:create ssl:endpoint
```

### Environment Variables Checklist
- [ ] `RAILS_ENV=production`
- [ ] `RACK_ENV=production`
- [ ] `SECRET_KEY_BASE` (generated)
- [ ] `RAILS_MASTER_KEY` (from config/master.key)
- [ ] `OPENAI_API_KEY` (from OpenAI dashboard)
- [ ] `SENDGRID_USERNAME` (auto-set by addon)
- [ ] `SENDGRID_PASSWORD` (auto-set by addon)
- [ ] `APP_DOMAIN` (your-app.herokuapp.com)
- [ ] `RAILS_SERVE_STATIC_FILES=enabled`
- [ ] `RAILS_LOG_TO_STDOUT=enabled`

## Success Criteria

- [ ] Application successfully deployed and accessible on Heroku
- [ ] All environment variables properly configured
- [ ] Database migrations run successfully in production
- [ ] Email delivery working through SendGrid
- [ ] SSL certificate properly configured and active
- [ ] Voice assessment flow works end-to-end in production
- [ ] Admin authentication and management functions working
- [ ] Performance monitoring and error tracking active
- [ ] Backup system operational and tested
- [ ] All security headers and policies properly configured

## Performance Targets

- **Page Load Time**: < 2 seconds for main pages
- **API Response Time**: < 500ms for standard requests
- **Email Delivery**: < 30 seconds for transactional emails
- **Database Query Time**: < 100ms for typical queries
- **SSL Handshake**: < 300ms
- **Uptime Target**: 99.9% availability

## Security Checklist

- [ ] Force SSL enabled for all connections
- [ ] Security headers properly configured (HSTS, CSP, etc.)
- [ ] Rate limiting enabled for API endpoints
- [ ] Environment variables secured (no secrets in code)
- [ ] Database connections encrypted
- [ ] Email communications secured
- [ ] Regular security updates scheduled
- [ ] Vulnerability scanning configured

## Cost Optimization

### Heroku Dyno Usage
- **Web Dyno**: Standard-1X ($25/month) for production
- **Worker Dyno**: Optional for background jobs
- **Database**: Heroku Postgres Mini ($9/month)
- **Email**: SendGrid Starter (Free tier: 100 emails/day)

### Monitoring Costs
- **Error Tracking**: Sentry F1 (Free tier)
- **APM**: New Relic Wayne (Free tier)
- **Total Estimated**: ~$35-50/month for small production deployment

## Next Steps

After Task 8 completion:
- **Task 9**: Assessment Results Review and Admin Analytics
- **Task 10**: Final testing, security audit, and performance optimization
- **Go Live**: Launch production application for LaunchPad Lab client use
- **Maintenance**: Establish ongoing monitoring and update procedures

## Rollback Strategy

### Emergency Rollback Procedure
1. **Immediate**: `heroku releases:rollback` to previous version
2. **Database**: Restore from most recent backup if needed
3. **DNS**: Update if custom domain affected
4. **Monitoring**: Verify all systems operational after rollback
5. **Investigation**: Analyze logs to determine root cause
6. **Communication**: Notify stakeholders of status and timeline

### Staged Deployment Approach
1. **Staging Environment**: Deploy to staging first for validation
2. **Blue-Green Deployment**: Use Heroku's review apps for testing
3. **Feature Flags**: Implement toggles for new features
4. **Database Migrations**: Test all migrations on staging data first
5. **Monitoring**: Monitor key metrics during and after deployment 