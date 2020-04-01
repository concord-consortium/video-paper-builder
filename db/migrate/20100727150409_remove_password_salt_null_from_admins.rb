class RemovePasswordSaltNullFromAdmins < ActiveRecord::Migration[5.1]
  def self.up
    change_column :admins, :encrypted_password, :string, :null => true
    change_column :admins, :password_salt, :string, :null => true
  end

  def self.down
  end
end
