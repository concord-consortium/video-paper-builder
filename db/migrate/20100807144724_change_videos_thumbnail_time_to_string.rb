class ChangeVideosThumbnailTimeToString < ActiveRecord::Migration
  def self.up
    change_column :videos, :thumbnail_time, :string
  end

  def self.down
    change_column :videos, :thumbnail_time, :integer
  end
end
