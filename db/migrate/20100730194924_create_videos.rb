class CreateVideos < ActiveRecord::Migration[5.1]
  def self.up
    create_table :videos do |t|
      t.string :entry_id
      t.text :description
      t.integer :video_paper_id

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
