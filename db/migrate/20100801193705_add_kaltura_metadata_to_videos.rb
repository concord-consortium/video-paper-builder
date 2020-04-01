class AddKalturaMetadataToVideos < ActiveRecord::Migration[5.1]
  def self.up
    add_column :videos, :duration, :string
    add_column :videos, :processed, :boolean
    add_column :videos, :thumbnail_time, :integer
  end

  def self.down
    remove_column :videos, :thumbnail_time
    remove_column :videos, :processed
    remove_column :videos, :duration
  end
end
