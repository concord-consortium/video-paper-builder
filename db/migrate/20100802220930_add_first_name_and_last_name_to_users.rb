class AddFirstNameAndLastNameToUsers < ActiveRecord::Migration[5.1]
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end

  def self.down
    remove_column :users, :last_name
    remove_column :users, :first_name
  end
end
