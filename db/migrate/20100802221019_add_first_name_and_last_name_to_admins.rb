class AddFirstNameAndLastNameToAdmins < ActiveRecord::Migration[5.1]
  def self.up
    add_column :admins, :first_name, :string
    add_column :admins, :last_name, :string
  end

  def self.down
    remove_column :admins, :last_name
    remove_column :admins, :first_name
  end
end
