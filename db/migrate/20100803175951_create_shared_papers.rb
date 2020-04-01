class CreateSharedPapers < ActiveRecord::Migration[5.1]
  def self.up
    create_table :shared_papers do |t|
      t.integer :video_paper_id
      t.integer :user_id
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :shared_papers
  end
end
