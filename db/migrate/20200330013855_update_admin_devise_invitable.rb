class UpdateAdminDeviseInvitable < ActiveRecord::Migration
  def up
    add_column :admins, :invitation_created_at, :datetime
    change_column :admins, :invitation_token, :string, limit: nil
  end

  def down
    remove_column :admins, :invitation_created_at
    change_column :admins, :invitation_token, :string, limit: 60
  end
end
