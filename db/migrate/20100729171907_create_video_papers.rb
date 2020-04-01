class CreateVideoPapers < ActiveRecord::Migration[5.1]
  def self.up
    create_table :video_papers do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :video_papers
  end
end
