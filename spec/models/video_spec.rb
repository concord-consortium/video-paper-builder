require 'spec_helper'

describe Video do

  it "should only have one video per video paper" do
    paper = FactoryBot.build(:video_paper)

    first_video = FactoryBot.build(:video, :video_paper => paper)
    expect(first_video.save).to be_truthy

    second_video = FactoryBot.build(:video, :video_paper => paper)
    expect(second_video.save).to be_falsey
  end

  it "should remove the domain and bucket from the upload_uri when saved" do
    paper = FactoryBot.build(:video_paper)
    video = FactoryBot.build(:video, :video_paper => paper, :upload_uri => "#{S3DirectUpload.config.url}foo")
    expect(video.save).to be_truthy
    video.reload
    expect(video.upload_uri).to eq "foo"
  end

  it "should respond appropriately to public?" do
    video = FactoryBot.build(:video, :private => false)
    expect(video.public?).to be_truthy

    video = FactoryBot.build(:video, :private => true)
    expect(video.public?).to be_falsey
  end

  it "should respond appropriately to private?" do
    video = FactoryBot.build(:video, :private => false)
    expect(video.private?).to be_falsey

    video = FactoryBot.build(:video, :private => true)
    expect(video.private?).to be_truthy
  end

  it "should allow a nil thumbnail_time" do
    video = FactoryBot.build(:video, :thumbnail_time => nil)
    expect(video).to be_valid
  end

  it "should allow a blank thumbnail_time" do
    video = FactoryBot.build(:video, :thumbnail_time => '')
    expect(video).to be_valid
  end

  it "should allow a basic, numeric thumbnail_time" do
    video = FactoryBot.build(:video, :thumbnail_time => '150')
    expect(video).to be_valid
  end

  it "should allow a properly timecoded hh:mm:ss time" do
    video = FactoryBot.build(:video, :thumbnail_time => '00:02:30')
    expect(video).to be_valid
    expect(video.thumbnail_time).to eq("150")
  end

  it "shouldn't allow a non-numeric time format" do
    video = FactoryBot.build(:video, :thumbnail_time => 'waffles')
    expect(video).to be_invalid
  end

  it "shouldn't allow a non-numeric time format in hh:mm:ss either" do
    video = FactoryBot.build(:video, :thumbnail_time => 'waffles:05:12')
    expect(video).to be_invalid
  end

  it "shouldn't allow a seconds over 60 in hh:mm:ss format" do
    video = FactoryBot.build(:video, :thumbnail_time => '00:00:61')
    expect(video).to be_invalid
  end

  it "shouldn't allow a minutes over 60 in hh:mm:ss format" do
    video = FactoryBot.build(:video, :thumbnail_time => '00:61:05')
    expect(video).to be_invalid
  end

  it "shouldn't anything over a day long in hh:mm:ss format" do
    video = FactoryBot.build(:video, :thumbnail_time => '25:00:02')
    expect(video).to be_invalid
  end

  it "should allow a timestamp just under one day" do
    video = FactoryBot.build(:video, :thumbnail_time => '23:59:59')
    expect(video).to be_valid
  end

  it "should not provide an upload filename if no file has been uploaded" do
    video = FactoryBot.build(:video, :upload_uri => nil)
    expect(video.upload_filename).to be_nil
  end

  it "should provide an upload filename if a file has been uploaded" do
    video = FactoryBot.build(:video, :upload_uri => "/foo/bar/baz.mp3")
    expect(video.upload_filename).to eq "baz.mp3"
  end

  it "should not generate a signed url if it hasn't been transcoded" do
    video = FactoryBot.build(:video)
    expect(video.generate_signed_url).to be_nil
  end

  it "should generate a signed url if it has been transcoded" do
    video = FactoryBot.build(:video, :transcoded_uri => "foo/bar/baz.mp3", :aws_transcoder_state => "completed")
    signed_url = video.generate_signed_url
    expect(signed_url).to include "https://s3.amazonaws.com/"
    expect(signed_url).to include "foo/bar/baz.mp3"
  end

  it "should not generate a signed thumbnail url if it hasn't been transcoded" do
    video = FactoryBot.build(:video)
    expect(video.generate_signed_thumbnail_url).to be_nil
  end

  it "should generate a signed url if it has been transcoded" do
    video = FactoryBot.build(:video, :transcoded_uri => "foo/bar/baz.mp3", :aws_transcoder_state => "completed")
    signed_url = video.generate_signed_thumbnail_url
    expect(signed_url).to include "https://s3.amazonaws.com/"
    expect(signed_url).to include "foo/bar/baz.mp3"
  end

  it "should not generate a thumbnail url if there is no thumbnail" do
    video = FactoryBot.build(:video, :thumbnail => nil)
    expect(video.generate_thumbnail_url).to be_nil
  end

  it "should generate a thumbnail url when there is a thumbnail" do
    video = FactoryBot.build(:video_with_thumbnail)
    signed_url = video.generate_thumbnail_url
    expect(signed_url).to include "thumbnail.jpeg"
  end

  it "should generate a thumbnail url when it has been transcoded" do
    video = FactoryBot.build(:video, :transcoded_uri => "foo/bar/baz.mp3", :aws_transcoder_state => "completed")
    signed_url = video.generate_thumbnail_url
    expect(signed_url).to include "https://s3.amazonaws.com/"
    expect(signed_url).to include "foo/bar/baz.mp3"
  end

  describe "aws transcoding" do
    before(:each) do
      @video = FactoryBot.build(:video)
      @transcoder = Aws::ElasticTranscoder::Client.new
      allow(@transcoder).to receive(:create_job).and_return({:job => {:id => "1"}})
      allow(@transcoder).to receive(:cancel_job).and_return(nil)
    end

    it "should support start_transcoding_job" do
      expect(@video.aws_transcoder_job).to be_nil
      expect(@video.aws_transcoder_state).to be_nil
      @video.start_transcoding_job(true, @transcoder)
      @video.reload
      expect(@video.aws_transcoder_job).to eq "1"
      expect(@video.aws_transcoder_state).to eq "submitted"
    end

    it "should support retry_transcoding_job" do
      @video.start_transcoding_job(true, @transcoder)
      @video.reload
      expect(@video.aws_transcoder_job).to eq "1"
      expect(@video.aws_transcoder_state).to eq "submitted"
      expect(@video.aws_transcoder_submitted_at).to eq @video.aws_transcoder_first_submitted_at
      sleep(2)
      @video.retry_transcoding_job(@transcoder)
      @video.reload
      expect(@video.aws_transcoder_submitted_at).to_not eq @video.aws_transcoder_first_submitted_at
    end

    it "should support cancel_transcoding_job" do
      @video.start_transcoding_job(true, @transcoder)
      @video.reload
      expect(@video.aws_transcoder_job).to eq "1"
      expect(@video.aws_transcoder_state).to eq "submitted"
      sleep(2)
      @video.cancel_transcoding_job(@transcoder)
      @video.reload
      expect(@video.aws_transcoder_job).to be_nil
      expect(@video.aws_transcoder_state).to eq "cancelled"
    end
  end
end
