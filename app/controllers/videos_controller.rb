require 'yaml'

class VideosController < ApplicationController

  WEB_MP4_PRESET_ID = '1351620000000-100070'

  before_filter :authenticate_any_user!
  before_filter :get_video_paper_and_owner_from_request
  before_filter :authenticate_owner!
  before_filter :authenticate_admin!, :only=>[:show]
  before_filter :video_exists?, :only=>[:new,:create]
  before_filter :no_video?,:only=>[:index]

  def index
    @video = @video_paper.video
  end

  def show
    @video = Video.find(params[:id])
    @info = {
      :upload_uri => @video.upload_uri,
      :transcoded_uri => @video.transcoded_uri,
      :aws_transcoder_state => @video.aws_transcoder_state,
      :aws_transcoder_submitted_at => @video.aws_transcoder_submitted_at,
      :aws_transcoder_job => @video.aws_transcoder_job,
      :aws_transcoder_last_notification => @video.aws_transcoder_last_notification ? YAML.load(@video.aws_transcoder_last_notification) : null
    }
  end

  def new
    @video = Video.new
    # make videos public by default because of confusing UI
    @video.private = false
  end

  def create
    if owner_or_admin
      if !params[:video].has_key?(:private)
        params[:video][:private] = false
      end
      @video = Video.new(params[:video])
      unless @video.video_paper_id
        @video.video_paper = @video_paper
      end

      if @video.save
        start_transcoding_job()
        redirect_to(@video_paper,:notice=>"Your video was successfully updated!")
      else
        respond_to do |format|
          render "new"
        end
      end
    else
      redirect_to( root_path,:notice=>"You are not authorized to add a video to this Video Paper.")
    end
  end

  def edit
    @video = Video.find(params[:id])
  end

  def update
    @video = Video.find(params[:id])
    old_upload_uri = @video.upload_uri
    if @video.update_attributes(params[:video])
      unless params[:video][:upload_uri] == old_upload_uri
        if !@video.processed
          cancel_transcoding_job()
        end
        @video.transcoded_uri = nil
        @video.processed = false
        @video.duration = nil
        @video.save
        start_transcoding_job()
      end
      redirect_to(my_video_papers_path, :notice=>"Your video was sucessfully updated!")
    else
      render "edit"
    end
  end

  protected
  # gets the video paper id from from the parameter, then gets the owner from that paper
  def get_video_paper_and_owner_from_request
    @video_paper = VideoPaper.find(params[:video_paper_id])
    @owner = @video_paper.user
  end
  def video_exists?
    if @video_paper.video
      redirect_to( edit_video_paper_video_path(@video_paper,@video_paper.video),
        :notice=>"You already have a video, you can edit it instead!"
      )
    end
  end
  def no_video?
    unless @video_paper.video
      redirect_to( new_video_paper_video_path(@video_paper),
        :notice=>"You should start by making a video!"
      )
    end
  end

  def authenticate_owner!
    unless owner_or_admin
      redirect_to(root_path, :notice => "You aren't authorized for this action.")
    end
  end

  def owner_or_admin
    (@owner == current_user && current_user) || current_admin
  end

  def cancel_transcoding_job
    if !@video.aws_transcoder_job.nil?
      begin
        transcoder = AWS::ElasticTranscoder::Client.new
        transcoder.cancel_job id: @video.aws_transcoder_job
      rescue AWS::ElasticTranscoder::Errors::ResourceInUseException
        # this is raised if the job is current transcoding
      end
      @video.aws_transcoder_job = nil
      @video.aws_transcoder_state = 'cancelled'
      @video.aws_transcoder_submitted_at = nil
      @video.aws_transcoder_last_notification = nil
      @video.save!
    end
  end

  def start_transcoding_job
    transcoded_uri = "transcoded/#{@video.id}/#{Time.now.to_i}/#{@video.upload_filename}"
    @video.transcoded_uri = transcoded_uri

    transcoder = AWS::ElasticTranscoder::Client.new
    result = transcoder.create_job(
      pipeline_id: VPB::Application.config.aws[:transcoder][:pipeline_id],
      input: {
        key: @video.upload_uri,
        frame_rate: 'auto',
        resolution: 'auto',
        aspect_ratio: 'auto',
        interlaced: 'auto',
        container: 'auto'
      },
      output: {
        key: transcoded_uri,
        preset_id: WEB_MP4_PRESET_ID,
        thumbnail_pattern: "#{transcoded_uri}-{count}",
        rotate: 'auto'
      }
    )
    @video.aws_transcoder_job = result[:job][:id]
    @video.aws_transcoder_state = 'submitted'
    @video.aws_transcoder_submitted_at = Time.now
    @video.aws_transcoder_last_notification = nil;
    @video.save!
  end
end
