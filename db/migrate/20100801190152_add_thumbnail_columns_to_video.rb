class AddThumbnailColumnsToVideo < ActiveRecord::Migration
  def self.up
    add_column :videos, :thumbnail_file_name, :string
    add_column :videos, :thumbnail_content_type, :string
    add_column :videos, :thumbnail_file_size, :integer
    add_column :videos, :thumbnail_updated_at, :datetime
  end

  def self.down
    remove_column :videos, :thumbnail_file_name
    remove_column :videos, :thumbnail_content_type
    remove_column :videos, :thumbnail_file_size
    remove_column :videos, :thumbnail_updated_at
  end
end
