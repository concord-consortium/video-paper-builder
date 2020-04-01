class AddRetriesToVideo < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :aws_transcoder_retries, :integer, default: 0
    # we need to keep track of the first time the job was submitted so we can tell the user
    # the total time since this submission
    add_column :videos, :aws_transcoder_first_submitted_at, :datetime
  end
end
