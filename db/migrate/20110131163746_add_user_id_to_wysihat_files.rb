class AddUserIdToWysihatFiles < ActiveRecord::Migration
  def self.up
    add_column :wysihat_files, :user_id, :integer    
  end

  def self.down
    remove_column :wysihat_files, :user_id
  end
end
