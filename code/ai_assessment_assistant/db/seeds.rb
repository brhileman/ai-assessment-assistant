# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "🌱 Starting database seed..."

# Admin allowlist - these emails are authorized for admin access
admin_emails = [
  'admin@launchpadlab.com',
  'assessment@launchpadlab.com'
]

puts "Setting up admin allowlist..."

admin_emails.each do |email|
  admin = Admin.find_or_create_by(email: email)
  if admin.persisted?
    puts "✓ Admin created/found: #{email}"
  else
    puts "✗ Failed to create admin: #{email} - #{admin.errors.full_messages.join(', ')}"
  end
end

puts "Admin setup complete!"

# Development seed data - only create in development environment
if Rails.env.development?
  puts "\n📊 Creating development seed data..."
  
  # Create sample companies
  companies_data = [
    {
      name: "TechCorp Industries",
      custom_instructions: "Focus on technical innovation and software development practices. Emphasize teamwork, agile methodologies, and continuous learning in all assessments."
    },
    {
      name: "Global Consulting Group",
      custom_instructions: "Professional services firm focused on client relationships and strategic advisory. Emphasize communication skills, business acumen, and problem-solving abilities."
    },
    {
      name: "StartupLab Inc",
      custom_instructions: "Fast-paced startup environment. Look for adaptability, creativity, and entrepreneurial spirit. Value quick decision-making and innovation."
    },
    {
      name: "Enterprise Solutions Corp",
      custom_instructions: "Large enterprise focused on scalability and process optimization. Assess leadership potential, strategic thinking, and ability to work in complex organizational structures."
    },
    {
      name: "Creative Agency Partners",
      custom_instructions: "Creative agency emphasizing collaboration, artistic vision, and client satisfaction. Focus on creativity, communication, and project management skills."
    }
  ]
  
  puts "Creating companies..."
  companies = companies_data.map do |company_data|
    company = Company.find_or_create_by(name: company_data[:name]) do |c|
      c.custom_instructions = company_data[:custom_instructions]
    end
    puts "✓ Company: #{company.name}"
    company
  end
  
  # Create stakeholders for each company
  puts "\nCreating stakeholders..."
  
  stakeholder_names = [
    "Sarah Johnson", "Michael Chen", "Emily Rodriguez", "David Kim", "Jennifer Walsh",
    "Alexander Thompson", "Maria Gonzalez", "Ryan O'Connor", "Lisa Zhang", "James Mitchell",
    "Amanda Foster", "Carlos Rivera", "Rachel Green", "Kevin Patel", "Nicole Williams"
  ]
  
  stakeholders = []
  companies.each_with_index do |company, company_index|
    # Create 3-5 stakeholders per company
    stakeholder_count = [3, 4, 5].sample
    
    company_stakeholders = stakeholder_names.sample(stakeholder_count).map.with_index do |name, index|
      email_domain = case company.name
      when "TechCorp Industries" then "techcorp.com"
      when "Global Consulting Group" then "globalconsulting.com"
      when "StartupLab Inc" then "startuplab.io"
      when "Enterprise Solutions Corp" then "enterprisesolutions.com"
      when "Creative Agency Partners" then "creativeagency.com"
      else "example.com"
      end
      
      email = "#{name.downcase.gsub(' ', '.')}@#{email_domain}"
      
      stakeholder = Stakeholder.find_or_create_by(email: email, company: company) do |s|
        s.name = name
        s.status = [:invited, :assessment_started, :assessment_completed].sample
      end
      
      puts "✓ Stakeholder: #{stakeholder.name} (#{stakeholder.company.name})"
      stakeholders << stakeholder
      stakeholder
    end
    
    # Remove used names to avoid duplicates
    stakeholder_names -= company_stakeholders.map(&:name)
  end
  
  # Create assessments for some stakeholders
  puts "\nCreating assessments..."
  
  sample_transcripts = [
    "Hello, I'm excited to participate in this assessment. I believe my strongest qualities include leadership, problem-solving, and effective communication. In my previous role, I successfully led a team of 12 developers through a complex project that resulted in a 40% improvement in system performance. When faced with challenges, I take a methodical approach: first analyzing the situation, then consulting with relevant stakeholders, and finally implementing solutions with clear success metrics. I thrive in collaborative environments and believe that diverse perspectives lead to better outcomes. My goal is to contribute meaningfully to any organization by leveraging my technical expertise and leadership experience.",
    
    "Thank you for this opportunity. I've always been passionate about innovation and creative problem-solving. My background in consulting has taught me the importance of understanding client needs and delivering results that exceed expectations. I'm particularly skilled at translating complex technical concepts into language that non-technical stakeholders can understand. In my current role, I've managed projects worth over $2 million and maintained a 98% client satisfaction rate. I believe success comes from combining analytical thinking with emotional intelligence, and I'm always looking for ways to improve processes and outcomes.",
    
    "I appreciate the chance to share my thoughts. My approach to work is built on three core principles: continuous learning, effective collaboration, and delivering high-quality results. I've found that staying curious and asking the right questions often leads to breakthrough solutions. In my experience, the best teams are those where every member feels heard and valued. I enjoy mentoring junior colleagues and believe that knowledge sharing strengthens the entire organization. My technical skills in data analysis and project management, combined with my communication abilities, allow me to bridge gaps between different departments and drive successful outcomes.",
    
    "Good day! I'm enthusiastic about discussing my qualifications and vision. Throughout my career, I've focused on building scalable solutions and fostering team growth. I believe that technology should serve people, not the other way around. My experience includes leading cross-functional teams, implementing agile methodologies, and driving digital transformation initiatives. I'm particularly proud of a recent project where we reduced operational costs by 30% while improving customer satisfaction scores. I value transparency, accountability, and continuous improvement in everything I do.",
    
    "Thank you for considering my application. I bring a unique combination of technical expertise and business acumen to every role. My background spans both startup environments and large enterprises, giving me perspective on how to balance innovation with stability. I excel at identifying opportunities for process improvement and implementing solutions that deliver measurable results. Communication is key to my success - I believe in keeping stakeholders informed and engaged throughout every project. I'm excited about the possibility of contributing to your team's success and helping drive the organization forward."
  ]
  
  # Create assessments for about 60% of stakeholders
  assessment_stakeholders = stakeholders.sample((stakeholders.length * 0.6).round)
  
  assessment_stakeholders.each do |stakeholder|
    # Decide if assessment is completed or in progress
    is_completed = [true, false, true].sample # 2/3 chance of being completed
    
    if is_completed
      # Completed assessment
      completion_time = rand(1..7).days.ago + rand(0..23).hours + rand(0..59).minutes
      start_time = completion_time - rand(15..60).minutes
      
      assessment = Assessment.find_or_create_by(stakeholder: stakeholder) do |a|
        a.full_transcript = sample_transcripts.sample
        a.completed_at = completion_time
        a.created_at = start_time
      end
      
      # Update stakeholder status to completed
      stakeholder.update!(status: :assessment_completed)
      puts "✓ Completed assessment: #{stakeholder.name} (#{assessment.duration_minutes} min)"
    else
      # In-progress assessment
      start_time = rand(1..3).hours.ago
      
      assessment = Assessment.find_or_create_by(stakeholder: stakeholder) do |a|
        a.full_transcript = nil
        a.completed_at = nil
        a.created_at = start_time
      end
      
      # Update stakeholder status to started
      stakeholder.update!(status: :assessment_started)
      puts "✓ In-progress assessment: #{stakeholder.name}"
    end
  end
  
  # Update remaining stakeholders to invited status
  remaining_stakeholders = stakeholders - assessment_stakeholders
  remaining_stakeholders.each do |stakeholder|
    stakeholder.update!(status: :invited)
  end
  
  puts "\n📈 Development seed data summary:"
  puts "Companies: #{Company.count}"
  puts "Stakeholders: #{Stakeholder.count}"
  puts "Assessments: #{Assessment.count}"
  puts "  - Completed: #{Assessment.completed.count}"
  puts "  - In Progress: #{Assessment.in_progress.count}"
  puts "Invited (no assessment): #{Stakeholder.where(status: :invited).count}"
  
  puts "\n✅ Development seed data created successfully!"
end

puts "🌱 Database seed complete!"
