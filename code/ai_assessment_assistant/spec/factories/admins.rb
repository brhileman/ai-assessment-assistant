FactoryBot.define do
  factory :admin do
    email { "admin@launchpadlab.com" }
    
    # Additional factory for testing different scenarios
    factory :assessment_admin do
      email { "assessment@launchpadlab.com" }
    end
  end
end
