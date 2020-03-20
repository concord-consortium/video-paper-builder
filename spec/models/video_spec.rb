require 'spec_helper'

describe Video do

  it "should only have one video per video paper" do
    paper = FactoryGirl.build(:video_paper)

    first_video = FactoryGirl.build(:video, :video_paper => paper)
    first_video.save.should be_true

    second_video = FactoryGirl.build(:video, :video_paper => paper)
    second_video.save.should be_false
  end

  it "should remove the domain and bucket from the upload_uri when saved" do
    paper = FactoryGirl.build(:video_paper)
    video = FactoryGirl.build(:video, :video_paper => paper, :upload_uri => "#{S3DirectUpload.config.url}foo")
    video.save.should be_true
    video.reload
    video.upload_uri.should eq "foo"
  end

  it "should respond appropriately to public?" do
    video = FactoryGirl.build(:video, :private => false)
    video.public?.should be_true

    video = FactoryGirl.build(:video, :private => true)
    video.public?.should be_false
  end

  it "should respond appropriately to private?" do
    video = FactoryGirl.build(:video, :private => false)
    video.private?.should be_false

    video = FactoryGirl.build(:video, :private => true)
    video.private?.should be_true
  end

  it "should allow a nil thumbnail_time" do
    video = FactoryGirl.build(:video, :thumbnail_time => nil)
    video.should be_valid
  end

  it "should allow a blank thumbnail_time" do
    video = FactoryGirl.build(:video, :thumbnail_time => '')
    video.should be_valid
  end

  it "should allow a basic, numeric thumbnail_time" do
    video = FactoryGirl.build(:video, :thumbnail_time => '150')
    video.should be_valid
  end

  it "should allow a properly timecoded hh:mm:ss time" do
    video = FactoryGirl.build(:video, :thumbnail_time => '00:02:30')
    video.should be_valid
    video.thumbnail_time.should == 150
  end

  it "shouldn't allow a non-numeric time format" do
    video = FactoryGirl.build(:video, :thumbnail_time => 'waffles')
    video.should be_invalid
  end

  it "shouldn't allow a non-numeric time format in hh:mm:ss either" do
    video = FactoryGirl.build(:video, :thumbnail_time => 'waffles:05:12')
    video.should be_invalid
  end

  it "shouldn't allow a seconds over 60 in hh:mm:ss format" do
    video = FactoryGirl.build(:video, :thumbnail_time => '00:00:61')
    video.should be_invalid
  end

  it "shouldn't allow a minutes over 60 in hh:mm:ss format" do
    video = FactoryGirl.build(:video, :thumbnail_time => '00:61:05')
    video.should be_invalid
  end

  it "shouldn't anything over a day long in hh:mm:ss format" do
    video = FactoryGirl.build(:video, :thumbnail_time => '25:00:02')
    video.should be_invalid
  end

  it "should allow a timestamp just under one day" do
    video = FactoryGirl.build(:video, :thumbnail_time => '23:59:59')
    video.should be_valid
  end

  it "should not provide an upload filename if no file has been uploaded" do
    video = FactoryGirl.build(:video, :upload_uri => nil)
    video.upload_filename.should be_nil
  end

  it "should provide an upload filename if a file has been uploaded" do
    video = FactoryGirl.build(:video, :upload_uri => "/foo/bar/baz.mp3")
    video.upload_filename.should eq "baz.mp3"
  end

  it "should not generate a signed url if it hasn't been transcoded" do
    video = FactoryGirl.build(:video)
    video.generate_signed_url.should be_nil
  end

  it "should generate a signed url if it has been transcoded" do
    video = FactoryGirl.build(:video, :transcoded_uri => "foo/bar/baz.mp3", :aws_transcoder_state => "completed")
    signed_url = video.generate_signed_url
    signed_url.should include "https://s3.amazonaws.com/"
    signed_url.should include "foo/bar/baz.mp3"
  end

  it "should not generate a signed thumbnail url if it hasn't been transcoded" do
    video = FactoryGirl.build(:video)
    video.generate_signed_thumbnail_url.should be_nil
  end

  it "should generate a signed url if it has been transcoded" do
    video = FactoryGirl.build(:video, :transcoded_uri => "foo/bar/baz.mp3", :aws_transcoder_state => "completed")
    signed_url = video.generate_signed_thumbnail_url
    signed_url.should include "https://s3.amazonaws.com/"
    signed_url.should include "foo/bar/baz.mp3"
  end

  it "should not generate a thumbnail url if there is no thumbnail" do
    video = FactoryGirl.build(:video, :thumbnail => nil)
    video.generate_thumbnail_url.should be_nil
  end

  it "should generate a thumbnail url when there is a thumbnail" do
    video = FactoryGirl.build(:video_with_thumbnail)
    signed_url = video.generate_thumbnail_url
    signed_url.should include "thumbnail.jpeg"
  end

  it "should generate a thumbnail url when it has been transcoded" do
    video = FactoryGirl.build(:video, :transcoded_uri => "foo/bar/baz.mp3", :aws_transcoder_state => "completed")
    signed_url = video.generate_thumbnail_url
    signed_url.should include "https://s3.amazonaws.com/"
    signed_url.should include "foo/bar/baz.mp3"
  end

  describe "aws transcoding" do
    before(:each) do
      @video = FactoryGirl.build(:video)
      @transcoder = AWS::ElasticTranscoder::Client.new
      @transcoder.stub(:create_job).and_return({:job => {:id => "1"}})
      @transcoder.stub(:cancel_job).and_return(nil)
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
