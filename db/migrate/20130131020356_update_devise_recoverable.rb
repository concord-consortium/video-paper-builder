class UpdateDeviseRecoverable < ActiveRecord::Migration[5.1]
  def up
    change_table :users do |t|
      t.datetime :reset_password_sent_at
    end
  end

  def down
    remove_column :users, :reset_password_sent_at
  end
end
