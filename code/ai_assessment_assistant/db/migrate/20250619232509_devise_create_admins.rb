# frozen_string_literal: true

class DeviseCreateAdmins < ActiveRecord::Migration[8.0]
  def change
    create_table :admins do |t|
      ## Email for magic link authentication
      t.string :email, null: false, default: ""

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Magic link fields  
      t.datetime :magic_link_sent_at
      t.string   :magic_link_token

      t.timestamps null: false
    end

    add_index :admins, :email, unique: true
    add_index :admins, :magic_link_token, unique: true
  end
end
