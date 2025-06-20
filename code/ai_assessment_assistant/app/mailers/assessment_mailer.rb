class AssessmentMailer < ApplicationMailer
  default from: 'AI Assessment Team <assessment@launchpadlab.com>',
          reply_to: 'assessment@launchpadlab.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.assessment_mailer.stakeholder_invitation.subject
  #
  def stakeholder_invitation(stakeholder)
    @stakeholder = stakeholder
    @company = stakeholder.company
    @assessment_url = stakeholder_assessment_url(@stakeholder.invitation_token, host: host, protocol: protocol)
    
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
    Rails.env.production? ? ENV.fetch('MAILER_HOST', 'assessment.launchpadlab.com') : 'localhost:3000'
  end

  def protocol
    Rails.env.production? ? 'https' : 'http'
  end
end
