require "rails_helper"

RSpec.describe AssessmentMailer, type: :mailer do
  let(:company) { create(:company, name: "Test Company", custom_instructions: "Focus on AI adoption in healthcare") }
  let(:stakeholder) { create(:stakeholder, company: company, name: "John Doe", email: "john@example.com") }
  let(:assessment) do
    # Create assessment with a 15-minute duration by setting created_at and completed_at appropriately
    create(:assessment, 
           stakeholder: stakeholder, 
           created_at: 15.minutes.ago, 
           completed_at: Time.current)
  end

  describe "stakeholder_invitation" do
    let(:mail) { AssessmentMailer.stakeholder_invitation(stakeholder) }

    it "renders the headers" do
      expect(mail.subject).to eq("You're invited to complete an AI Assessment for Test Company")
      expect(mail.to).to eq(["john@example.com"])
      expect(mail.from).to eq(["assessment@launchpadlab.com"])
      expect(mail.reply_to).to eq(["assessment@launchpadlab.com"])
    end

    it "renders the HTML body" do
      html_body = mail.html_part.body.encoded
      expect(html_body).to include("Hi John Doe,")
      expect(html_body).to include("Test Company")
      expect(html_body).to include("Focus on AI adoption in healthcare")
      expect(html_body).to include("Start Your Assessment")
      expect(html_body).to include("LaunchPad Lab")
    end

    it "renders the text body" do
      text_body = mail.text_part.body.encoded
      expect(text_body).to include("Hi John Doe,")
      expect(text_body).to include("Test Company")
      expect(text_body).to include("Focus on AI adoption in healthcare")
      expect(text_body).to include("START YOUR ASSESSMENT:")
    end

    it "includes assessment URL with stakeholder token" do
      expect(mail.html_part.body.encoded).to include("/assessment/#{stakeholder.invitation_token}")
      expect(mail.text_part.body.encoded).to include("/assessment/#{stakeholder.invitation_token}")
    end
  end

  describe "assessment_completed" do
    let(:mail) { AssessmentMailer.assessment_completed(assessment) }

    it "renders the headers" do
      expect(mail.subject).to eq("Thank you for completing your AI Assessment")
      expect(mail.to).to eq(["john@example.com"])
      expect(mail.from).to eq(["assessment@launchpadlab.com"])
      expect(mail.reply_to).to eq(["assessment@launchpadlab.com"])
    end

    it "renders the HTML body" do
      html_body = mail.html_part.body.encoded
      expect(html_body).to include("Thank you, John Doe!")
      expect(html_body).to include("Test Company")
      expect(html_body).to include("15 minutes")
      expect(html_body).to include("What happens next?")
    end

    it "renders the text body" do
      text_body = mail.text_part.body.encoded
      expect(text_body).to include("Thank you, John Doe!")
      expect(text_body).to include("Test Company")
      expect(text_body).to include("15 minutes")
      expect(text_body).to include("What happens next?")
    end

    it "includes completion timestamp" do
      formatted_time = assessment.completed_at.strftime("%B %d, %Y at %I:%M %p")
      expect(mail.html_part.body.encoded).to include(formatted_time)
      expect(mail.text_part.body.encoded).to include(formatted_time)
    end
  end
end
