require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  describe "magic_link" do
    let(:admin) { create(:admin, email: "admin@launchpadlab.com") }
    let(:token) { "test-magic-link-token" }
    let(:mail) { AdminMailer.magic_link(admin, token) }

    it "renders the headers" do
      expect(mail.subject).to eq("AI Assessment Assistant - Admin Login Link")
      expect(mail.to).to eq(["admin@launchpadlab.com"])
      expect(mail.from).to eq(["brett@launchpadlab.com"])
    end

    it "renders the body" do
      html_body = mail.html_part ? mail.html_part.body.encoded : mail.body.encoded
      expect(html_body).to match("Hello, Admin!")
      expect(html_body).to match("Access Admin Dashboard")
      expect(html_body).to match(token)
    end
  end

end
