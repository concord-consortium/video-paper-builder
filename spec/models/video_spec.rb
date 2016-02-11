require 'spec_helper'

describe Video do

  it "should only have one video per video paper" do
    paper = FactoryGirl.build(:video_paper)

    first_video = FactoryGirl.build(:video, :video_paper => paper)
    first_video.save.should be_true

    second_video = FactoryGirl.build(:video, :video_paper => paper)
    second_video.save.should be_false
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
