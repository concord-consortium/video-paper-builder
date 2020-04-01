class AddOwnerIdToVideoPapers < ActiveRecord::Migration[5.1]
  def self.up
    add_column :video_papers, :owner_id, :integer
  end

  def self.down
    remove_column :video_papers, :owner_id
  end
end
