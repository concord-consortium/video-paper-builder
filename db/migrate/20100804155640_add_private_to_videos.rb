class AddPrivateToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :private, :boolean
  end

  def self.down
    remove_column :private, :status
  end
end
