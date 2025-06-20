# Preview all emails at http://localhost:3000/rails/mailers/assessment_mailer_mailer
class AssessmentMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/assessment_mailer_mailer/stakeholder_invitation
  def stakeholder_invitation
    AssessmentMailer.stakeholder_invitation
  end

  # Preview this email at http://localhost:3000/rails/mailers/assessment_mailer_mailer/assessment_completed
  def assessment_completed
    AssessmentMailer.assessment_completed
  end

end
