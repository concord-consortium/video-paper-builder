class FixAdminDeviseRecoverable < ActiveRecord::Migration[6.0]
  def up
    change_table :admins do |t|
      t.datetime :reset_password_sent_at
    end
  end

  def down
    remove_column :admins, :reset_password_sent_at
  end
end
