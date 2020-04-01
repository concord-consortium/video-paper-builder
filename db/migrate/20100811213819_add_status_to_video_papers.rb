class AddStatusToVideoPapers < ActiveRecord::Migration[5.1]
  def self.up
    add_column :video_papers, :status, :string, :default=>"unpublished"
  end

  def self.down
    remove_column :video_papers, :status
  end
end
