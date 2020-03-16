require 'spec_helper'

describe Section do
  it "should not create a new instance without a title" do
    section = FactoryGirl.build(:section, :title => nil)
    section.should be_invalid
  end

  it "should not create a new instance withtout a video paper" do
    section = FactoryGirl.build(:section, :video_paper => nil)
    section.should be_invalid
  end

  it "should create a new instance without content" do
    section = FactoryGirl.build(:section, :content => nil)
    section.should be_valid
  end

  it "should create a new instance without a start time" do
    section = FactoryGirl.build(:section, :video_stop_time => '18')
    section.should be_valid
  end

  it "should create a new instance without a stop time" do
    section = FactoryGirl.build(:section, :video_start_time => '18')
    section.should be_valid
  end

  it "should only allow a blank start/stop time" do
    section = FactoryGirl.build(:section, :video_start_time => '', :video_stop_time => '')
    section.should be_valid
  end

  it "shouldn't allow a character start time" do
    section = FactoryGirl.build(:section, :video_start_time => 'waffles', :video_stop_time => '18')
    section.save.should be_false
  end

  it "shouldn't allow a character stop time" do
    section = FactoryGirl.build(:section, :video_start_time => '18', :video_stop_time => 'waffles')
    section.should be_invalid
  end

  it "should allow a start time in hh:mm:ss format" do
    section = FactoryGirl.build(:section, :video_start_time => '00:00:01', :video_stop_time => '15')
    section.should be_valid
    section.video_start_time.should == 1
  end

  it "should allow a stop time in hh:mm:ss format" do
    section = FactoryGirl.build(:section, :video_start_time => '15', :video_stop_time => '00:00:18')
    section.should be_valid
    section.video_stop_time.should == 18
  end

  it "shouldn't allow an invalid hh:mm:ss time" do
    section = FactoryGirl.build(:section, :video_start_time => '15', :video_stop_time => '00:00:65')
    section.should be_invalid

    section = FactoryGirl.build(:section, :video_start_time => '15', :video_stop_time => '00:75:00')
    section.should be_invalid

    section = FactoryGirl.build(:section, :video_start_time => '15', :video_stop_time => '25:00:00')
    section.should be_invalid
  end

  it "shouldn't allow an entered stop time to be greater than the start time" do
    section = FactoryGirl.build(:section, :video_start_time => '15', :video_stop_time => '00:00:05')
    section.should be_invalid
  end

  describe "A section with an uploaded video" do
    before(:each) do
      @video = FactoryGirl.build(:video, :duration => '100')
    end

    it "should set the video start time to the video's duration - 1 second if the start time is too large" do
      duration = @video.duration
      section = FactoryGirl.build(:section, :video_start_time => (duration.to_i + 20), :video_stop_time => (duration.to_i + 21))
      section.video_paper.video = @video
      section.save.should be_true
      section.video_start_time.should  == (duration.to_i - 1)
    end

    it "should set the video stop time to the video's duration if the stop time is too large" do
      duration = @video.duration
      section = FactoryGirl.build(:section, :video_start_time => (duration.to_i + 20), :video_stop_time => (duration.to_i + 21))
      section.video_paper.video = @video
      section.save.should be_true
      section.video_stop_time.should  == duration.to_i
    end
  end

  it "should provide a reasonable timestamp formatted when given a time less than a minute" do
    section = FactoryGirl.build(:section)
    section.to_timestamp("22").should == "00:00:22"
    section.to_timestamp(15).should == "00:00:15"
  end

  it "should provide a reasonable timestamp formatted when given a time between a minute and an hour" do
    section = FactoryGirl.build(:section)
    section.to_timestamp("60").should == "00:01:00"
    section.to_timestamp(61).should == "00:01:01"
    section.to_timestamp(2053).should == "00:34:13"
    section.to_timestamp("3599").should == "00:59:59"
  end

  it "should provide a reasonable timestamp formatted when given a time greater than an hour" do
    section = FactoryGirl.build(:section)
    section.to_timestamp("3600").should == "01:00:00"
    section.to_timestamp("362624").should == "100:43:44"
  end

  it "shouldn't allow you to save a negative start/stop time" do
    section = FactoryGirl.build(:section, :video_start_time => '-12')
    section.should be_invalid
  end

  it "should call the super method on method_missing" do
    section = FactoryGirl.build(:section)
    lambda { section.this_method_does_not_exist() }.should raise_error(NoMethodError)
  end
end
