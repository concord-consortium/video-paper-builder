class AddLanguageIdToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :language_id, :integer
  end

  def self.down
    remove_column :videos, :language_id
  end
end
