class UpdateAdminInvitable < ActiveRecord::Migration[5.1]
  # this is pased on this readme:
  # https://github.com/scambra/devise_invitable

  def up
    change_column :admins, :invitation_token, :string, :limit => 60

    change_table :admins do |t|
      # this are all new
      t.datetime :invitation_accepted_at
      t.integer  :invitation_limit
      t.integer  :invited_by_id
      t.string   :invited_by_type
    end

    # this index already exists, but isn't marked unique
    # add_index :admins, :invitation_token, :unique => true

    # the default for encrypted_password is currently an empty string
    # so I think that takes care of this approach
    # Allow null encrypted_password
    # change_column :admins, :encrypted_password, :string, :null => true
  end

  def down
    remove_column :admins, :invitation_accepted_at
    remove_column :admins, :invitation_limit
    remove_column :admins, :invited_by_id
    remove_column :admins, :invited_by_type

    change_column :admins, :invitation_token, :string, :limit => 60
  end
end
