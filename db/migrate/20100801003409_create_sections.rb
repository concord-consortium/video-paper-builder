class CreateSections < ActiveRecord::Migration[5.1]
  def self.up
    create_table :sections do |t|
      t.string :title
      t.string :content
      t.integer :video_paper_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
