require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  describe "magic_link" do
    let(:mail) { AdminMailer.magic_link }

    it "renders the headers" do
      expect(mail.subject).to eq("Magic link")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
