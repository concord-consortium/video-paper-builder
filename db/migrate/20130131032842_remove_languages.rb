class RemoveLanguages < ActiveRecord::Migration
  def up
    remove_column :videos, :language_id
    drop_table :languages
  end

  def down
    create_table :languages do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    change_table :videos do |t|
      t.integer :language_id
    end
  end
end
