class UpdateUserInvitable < ActiveRecord::Migration
  # this is pased on this readme:
  # https://github.com/scambra/devise_invitable

  def up
    change_column :users, :invitation_token, :string, :limit => 60

    change_table :users do |t|
      # this are all new
      t.datetime :invitation_accepted_at
      t.integer  :invitation_limit
      t.integer  :invited_by_id
      t.string   :invited_by_type
    end

    # this index already exists, but isn't marked unique
    # add_index :users, :invitation_token, :unique => true

    # the default for encrypted_password is currently an empty string
    # so I think that takes care of this approach
    # Allow null encrypted_password
    # change_column :users, :encrypted_password, :string, :null => true
  end

  def down
    remove_column :users, :invitation_accepted_at
    remove_column :users, :invitation_limit
    remove_column :users, :invited_by_id
    remove_column :users, :invited_by_type

    change_column :users, :invitation_token, :string, :limit => 60
  end
end
