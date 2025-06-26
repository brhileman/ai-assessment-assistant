class AssessmentMailer < ApplicationMailer
  default from: 'AI Assessment Team <brett@launchpadlab.com>',
          reply_to: 'assessment@launchpadlab.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assessment_mailer.stakeholder_invitation.subject
  #
  def stakeholder_invitation(stakeholder)
    @stakeholder = stakeholder
    @company = stakeholder.company
    @assessment_url = assessment_url(@stakeholder.invitation_token, host: host, protocol: protocol)
    
    mail(
      to: @stakeholder.email,
      subject: "You're invited to complete an AI Assessment for #{@company.name}"
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assessment_mailer.assessment_completed.subject
  #
  def assessment_completed(assessment)
    @assessment = assessment
    @stakeholder = assessment.stakeholder
    @company = @stakeholder.company
    
    mail(
      to: @stakeholder.email,
      subject: "Thank you for completing your AI Assessment"
    )
  end

  private

  def host
    if Rails.env.production?
      ENV.fetch('APP_HOST', 'ai-assessment-assistant-9e4a484c0b2f.herokuapp.com')
    else
      'localhost:3000'
    end
  end

  def protocol
    Rails.env.production? ? 'https' : 'http'
  end
end
