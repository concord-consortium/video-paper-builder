class CreateLanguages < ActiveRecord::Migration[5.1]
  def self.up
    create_table :languages do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :languages
  end
end
