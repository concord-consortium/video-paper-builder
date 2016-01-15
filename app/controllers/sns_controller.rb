class MessageWasNotAuthentic < StandardError; end

class SnsController < ApplicationController

  def transcoder_update
    notification = JSON.parse request.raw_post

    case notification["Type"]
    when "SubscriptionConfirmation"
      # confirm the subscription
      raise MessageWasNotAuthentic if notification["SubscribeURL"] !~ /^https.*amazonaws\.com\//
      HTTParty.get notification["SubscribeURL"]

    when "Notification"
      message = JSON.parse notification["Message"]
      video = Video.find_by_aws_transcoder_job message["jobId"]
      # the video will be nil for jobs that were cancelled due to an immediate re-upload of a new video
      if video != nil
        state = message["state"].downcase
        video.aws_transcoder_state = state
        video.aws_transcoder_last_notification = message
        video.processed = (state == 'completed') || (state == 'warning')
        video.save!
      end

    when "UnsubscribeConfirmation"
      # nothing for now
    end

    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end
