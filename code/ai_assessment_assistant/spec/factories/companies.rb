FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    custom_instructions { Faker::Lorem.paragraph(sentence_count: 3) }
    
    trait :with_short_name do
      name { "#{Faker::Company.suffix} Corp" }
    end
    
    trait :with_long_instructions do
      custom_instructions { Faker::Lorem.paragraph(sentence_count: 10) }
    end
    
    trait :minimal do
      name { "Test Company" }
      custom_instructions { nil }
    end
    
    trait :tech_company do
      name { "#{Faker::Lorem.word.capitalize} Technologies" }
      custom_instructions { "Focus on technical innovation and software development practices. Emphasize teamwork, agile methodologies, and continuous learning." }
    end
    
    trait :consulting_company do
      name { "#{Faker::Lorem.word.capitalize} Consulting Group" }
      custom_instructions { "Professional services firm focused on client relationships and strategic advisory. Emphasize communication skills and business acumen." }
    end
  end
end
