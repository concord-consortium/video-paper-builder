class UpdateDeviseRecoverable < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.datetime :reset_password_sent_at
    end
  end

  def down
    remove_column :users, :reset_password_sent_at
  end
end
