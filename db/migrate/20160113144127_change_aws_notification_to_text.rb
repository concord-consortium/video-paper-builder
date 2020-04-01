class ChangeAwsNotificationToText < ActiveRecord::Migration[5.1]
  def up
    change_column :videos, :aws_transcoder_last_notification, :text
  end

  def down
    change_column :videos, :aws_transcoder_last_notification, :string
  end
end
