class AddInvitationSentAtToStakeholders < ActiveRecord::Migration[8.0]
  def change
    add_column :stakeholders, :invitation_sent_at, :datetime
  end
end
