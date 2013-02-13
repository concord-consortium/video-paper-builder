require 'spec_helper'

describe Video do

  before(:each) do
    KalturaFu.stub(:set_video_description)
    KalturaFu.stub(:set_category)
    KalturaFu.stub_chain(:get_video_info, :duration).and_return(100)
  end

  it "should require a kaltura entry" do
    video = FactoryGirl.build(:video, :entry_id => nil)
    video.should be_invalid
  end

  it "should only have one video per video paper" do
    paper = FactoryGirl.build(:video_paper)

    first_video = FactoryGirl.build(:video, :video_paper => paper)
    first_video.save.should be_true

    second_video = FactoryGirl.build(:video, :video_paper => paper)
    second_video.save.should be_false
  end

  it "should add the description to the Kaltura metadata" do
    description = rand(100).to_s + "waffles yo."
    video = FactoryGirl.build(:video, :description => description)
    KalturaFu.should_receive(:set_video_description).with(video.entry_id, description)
    video.save.should be_true
  end

  it "should set the kaltura category to the rails environment" do
    video = FactoryGirl.build(:video)
    KalturaFu.should_receive(:set_category).with(video.entry_id, Rails.env)
    video.save.should be_true
  end

  it "should snag the video duration from kaltura after saving" do
    KalturaFu.stub_chain(:get_video_info, :duration).and_return(999)
    video = FactoryGirl.build(:video)
    video.save.should be_true

    video.duration.should == 999
  end

  it "should update the processing status from kaltura" do
    video = FactoryGirl.build(:video, :processed => false)
    KalturaFu.should_receive(:check_video_status).and_return(KalturaFu::READY)
    video.processed?.should == true
  end

  it "should ask Kaltura about the status only if it has not been processed" do
    video = FactoryGirl.build(:video, :processed => true)
    KalturaFu.should_not_receive(:check_video_status)
    video.processed?.should == true
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

end