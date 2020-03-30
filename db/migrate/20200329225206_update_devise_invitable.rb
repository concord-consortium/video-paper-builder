class UpdateDeviseInvitable < ActiveRecord::Migration
  def up
    add_column :users, :invitation_created_at, :datetime
    change_column :users, :invitation_token, :string, limit: nil
  end

  def down
    remove_column :users, :invitation_created_at
    change_column :users, :invitation_token, :string, limit: 60
  end
end

