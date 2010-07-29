class AddOwnerIdToVideoPapers < ActiveRecord::Migration
  def self.up
    add_column :video_papers, :owner_id, :integer
  end

  def self.down
    remove_column :video_papers, :owner_id
  end
end
