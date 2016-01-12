class AddTranscoderJob < ActiveRecord::Migration
  def up
    add_column :videos, :transcoded_uri, :string
    add_column :videos, :aws_transcoder_job, :string
    add_column :videos, :aws_transcoder_state, :string
    add_column :videos, :aws_transcoder_submitted_at, :datetime
    add_column :videos, :aws_transcoder_last_notification, :string
  end

  def down
    remove_column :videos, :transcoded_uri
    remove_column :videos, :aws_transcoder_job
    remove_column :videos, :aws_transcoder_state
    remove_column :videos, :aws_transcoder_submitted_at
    remove_column :videos, :aws_transcoder_last_notification
  end
end
