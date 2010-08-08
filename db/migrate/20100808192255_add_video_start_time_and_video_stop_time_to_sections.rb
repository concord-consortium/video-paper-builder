class AddVideoStartTimeAndVideoStopTimeToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :video_start_time, :string
    add_column :sections, :video_stop_time, :string
  end

  def self.down
    remove_column :sections, :video_stop_time
    remove_column :sections, :video_start_time
  end
end
