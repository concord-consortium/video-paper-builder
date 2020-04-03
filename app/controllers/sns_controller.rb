class MessageWasNotAuthentic < StandardError; end

class SnsController < ApplicationController

  def transcoder_update
    sleep_before_retry = ENV["RAILS_ENV"] == "test" ? 0 : 7
    notification = JSON.parse request.raw_post

    case notification["Type"]
    when "SubscriptionConfirmation"
      # confirm the subscription
      raise MessageWasNotAuthentic if notification["SubscribeURL"] !~ /^https.*amazonaws\.com\//
      HTTParty.get notification["SubscribeURL"]

    when "Notification"
      message = notification["Message"]
      video = Video.find_by_aws_transcoder_job message["jobId"]
      # the video will be nil for jobs that were cancelled due to an immediate re-upload of a new video
      if video != nil
        state = message["state"].downcase
        video.aws_transcoder_last_notification = message
        if state == 'error' && message["errorCode"] == 3001
          retry_transcoding(video, sleep_before_retry)
        else
          video.aws_transcoder_state = state
          video.processed = (state == 'completed') || (state == 'warning')
          if !message["outputs"].nil? && !message["outputs"][0].nil? && message["outputs"][0].has_key?("duration")
            video.duration = message["outputs"][0]["duration"]
          else
            video.duration = 0
          end
        end
        video.save!
      end

    when "UnsubscribeConfirmation"
      # nothing for now
    end

    render :body => nil, :status => 200, :content_type => 'text/html'
  end

  private

  def retry_limit
    (ENV['TRANSCODER_RETRY_LIMIT'] || 20).to_i
  end

  # retry_transcoding is counting on retry_transcoding_job as well as the caller to save the video
  def retry_transcoding(video, sleep_before_retry)
    if video.aws_transcoder_retries < retry_limit
      # sleep a while, the most likely cause of the retry is because the file isn't available in S3 yet
      # generally this is bad practice to sleep because it ties up a web process, but this app is not intended for
      # high usage and it is better to keep it simple without adding in background processing
      # SNS requires a response in 15 seconds so we sleep roughly half of that to be safe
      sleep sleep_before_retry
      video.aws_transcoder_retries += 1
      video.retry_transcoding_job
    end
  end
end
