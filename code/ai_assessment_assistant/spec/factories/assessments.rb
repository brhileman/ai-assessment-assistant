FactoryBot.define do
  factory :assessment do
    stakeholder { association :stakeholder }
    full_transcript { Faker::Lorem.paragraph(sentence_count: 50) }
    completed_at { nil }
    started_at { nil }
    
    trait :started do
      started_at { 1.hour.ago }
      completed_at { nil }
      full_transcript { nil }
    end
    
    trait :completed do
      started_at { 2.hours.ago }
      completed_at { Faker::Time.between(from: 30.minutes.ago, to: Time.current) }
      full_transcript { 
        [
          "Hello, I'm excited to participate in this assessment.",
          "I believe my strengths include leadership and communication.",
          "In challenging situations, I try to remain calm and analytical.",
          "I work well in teams and enjoy collaborating with others.",
          "My goal is to contribute meaningfully to any organization I join.",
          "Thank you for this opportunity to share my thoughts."
        ].join(" ") + " " + Faker::Lorem.paragraph(sentence_count: 40)
      }
    end
    
    trait :in_progress do
      started_at { 30.minutes.ago }
      completed_at { nil }
      full_transcript { nil }
    end
    
    trait :with_short_transcript do
      full_transcript { "Hello, this is a brief assessment response." }
    end
    
    trait :with_long_transcript do
      full_transcript { Faker::Lorem.paragraph(sentence_count: 200) }
    end
    
    trait :completed_recently do
      completed_at { 5.minutes.ago }
      full_transcript { 
        "I appreciate the opportunity to discuss my background and experience. " +
        Faker::Lorem.paragraph(sentence_count: 30)
      }
    end
    
    trait :completed_yesterday do
      completed_at { 1.day.ago }
      full_transcript { Faker::Lorem.paragraph(sentence_count: 60) }
    end
    
    trait :quick_completion do
      completed_at { 5.minutes.from_now }
      full_transcript { "Quick assessment completed successfully." }
      
      after(:build) do |assessment|
        assessment.created_at = 10.minutes.ago if assessment.created_at.nil?
      end
    end
    
    trait :lengthy_completion do
      completed_at { 45.minutes.from_now }
      full_transcript { 
        "This was a comprehensive assessment covering multiple topics. " +
        Faker::Lorem.paragraph(sentence_count: 100)
      }
      
      after(:build) do |assessment|
        assessment.created_at = 1.hour.ago if assessment.created_at.nil?
      end
    end
  end
end
