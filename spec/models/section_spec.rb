require 'spec_helper'

describe Section do
  it "should not create a new instance without a title" do
    section = FactoryBot.build(:section, :title => nil)
    expect(section).to be_invalid
  end

  it "should not create a new instance withtout a video paper" do
    section = FactoryBot.build(:section, :video_paper => nil)
    expect(section).to be_invalid
  end

  it "should create a new instance without content" do
    section = FactoryBot.build(:section, :content => nil)
    expect(section).to be_valid
  end

  it "should create a new instance without a start time" do
    section = FactoryBot.build(:section, :video_stop_time => '18')
    expect(section).to be_valid
  end

  it "should create a new instance without a stop time" do
    section = FactoryBot.build(:section, :video_start_time => '18')
    expect(section).to be_valid
  end

  it "should only allow a blank start/stop time" do
    section = FactoryBot.build(:section, :video_start_time => '', :video_stop_time => '')
    expect(section).to be_valid
  end

  it "shouldn't allow a character start time" do
    section = FactoryBot.build(:section, :video_start_time => 'waffles', :video_stop_time => '18')
    expect(section.save).to be_falsey
  end

  it "shouldn't allow a character stop time" do
    section = FactoryBot.build(:section, :video_start_time => '18', :video_stop_time => 'waffles')
    expect(section).to be_invalid
  end

  it "should allow a start time in hh:mm:ss format" do
    section = FactoryBot.build(:section, :video_start_time => '00:00:01', :video_stop_time => '15')
    expect(section).to be_valid
    expect(section.video_start_time).to eq("1")
  end

  it "should allow a stop time in hh:mm:ss format" do
    section = FactoryBot.build(:section, :video_start_time => '15', :video_stop_time => '00:00:18')
    expect(section).to be_valid
    expect(section.video_stop_time).to eq("18")
  end

  it "shouldn't allow an invalid hh:mm:ss time" do
    section = FactoryBot.build(:section, :video_start_time => '15', :video_stop_time => '00:00:65')
    expect(section).to be_invalid

    section = FactoryBot.build(:section, :video_start_time => '15', :video_stop_time => '00:75:00')
    expect(section).to be_invalid

    section = FactoryBot.build(:section, :video_start_time => '15', :video_stop_time => '25:00:00')
    expect(section).to be_invalid
  end

  it "shouldn't allow an entered stop time to be greater than the start time" do
    section = FactoryBot.build(:section, :video_start_time => '15', :video_stop_time => '00:00:05')
    expect(section).to be_invalid
  end

  describe "A section with an uploaded video" do
    before(:each) do
      @video = FactoryBot.build(:video, :duration => '100')
    end

    it "should set the video start time to the video's duration - 1 second if the start time is too large" do
      duration = @video.duration
      section = FactoryBot.build(:section, :video_start_time => (duration.to_i + 20), :video_stop_time => (duration.to_i + 21))
      section.video_paper.video = @video
      expect(section.save).to be_truthy
      expect(section.video_start_time).to  eq("#{duration.to_i - 1}")
    end

    it "should set the video stop time to the video's duration if the stop time is too large" do
      duration = @video.duration
      section = FactoryBot.build(:section, :video_start_time => (duration.to_i + 20), :video_stop_time => (duration.to_i + 21))
      section.video_paper.video = @video
      expect(section.save).to be_truthy
      expect(section.video_stop_time).to  eq(duration)
    end
  end

  it "should provide a reasonable timestamp formatted when given a time less than a minute" do
    section = FactoryBot.build(:section)
    expect(section.to_timestamp("22")).to eq("00:00:22")
    expect(section.to_timestamp(15)).to eq("00:00:15")
  end

  it "should provide a reasonable timestamp formatted when given a time between a minute and an hour" do
    section = FactoryBot.build(:section)
    expect(section.to_timestamp("60")).to eq("00:01:00")
    expect(section.to_timestamp(61)).to eq("00:01:01")
    expect(section.to_timestamp(2053)).to eq("00:34:13")
    expect(section.to_timestamp("3599")).to eq("00:59:59")
  end

  it "should provide a reasonable timestamp formatted when given a time greater than an hour" do
    section = FactoryBot.build(:section)
    expect(section.to_timestamp("3600")).to eq("01:00:00")
    expect(section.to_timestamp("362624")).to eq("100:43:44")
  end

  it "shouldn't allow you to save a negative start/stop time" do
    section = FactoryBot.build(:section, :video_start_time => '-12')
    expect(section).to be_invalid
  end

  it "should call the super method on method_missing" do
    section = FactoryBot.build(:section)
    expect { section.this_method_does_not_exist() }.to raise_error(NoMethodError)
  end
end
