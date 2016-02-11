class CreateSchoologyRealms < ActiveRecord::Migration
  def change
    create_table :schoology_realms do |t|
      t.string :realm_type
      t.integer :schoology_id
      t.timestamps
    end
    add_index :schoology_realms, [:realm_type, :schoology_id], :unique => true
  end
end
