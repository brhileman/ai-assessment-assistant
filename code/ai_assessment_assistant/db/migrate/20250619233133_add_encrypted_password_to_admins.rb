class AddEncryptedPasswordToAdmins < ActiveRecord::Migration[8.0]
  def change
    add_column :admins, :encrypted_password, :string
  end
end
