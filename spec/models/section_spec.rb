require 'spec_helper'

describe Section do
  fixtures :languages

  before(:all) do
    @user  = FactoryGirl.create(:user, :email=>"spec_test12@velir.com")
    @video_paper = FactoryGirl.create(:video_paper, :owner_id => @user.id, :title => "valid title")
    
    #find a video with the category of "test" to eff with.
    KalturaFu.generate_session_key
    temp_filter = Kaltura::Filter::BaseFilter.new
    pager = Kaltura::FilterPager.new
    pager.page_size = 100000
    @entry = KalturaFu.client.media_service.list(temp_filter,pager).objects.map!{|c| c if c.categories == "test"}.compact!.last.id
    
    @video = Video.create(
      :entry_id => @entry,
      :description => "value for description",
      :video_paper_id => @video_paper.id,
      :language_id => Language.find_by_code('en').id,
      :private=> false
    )
  end

  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :video_paper_id => @video_paper.id,
      :video_start_time => '25',
      :video_stop_time => '35',
      :content => 'IM SUCH AWESOME CONTENT BRO'
    }  
  end
  
  it "should create a new instance given valid attributes" do
    section = Section.new(@valid_attributes)
    section.save.should be_true
  end

  it "should not create a new instance without a title" do
    invalid_attributes = {
      :video_paper_id => @video_paper.id,
      :video_start_time => '25',
      :video_stop_time => '35',
      :content => 'IM SUCH AWESOME CONTENT BRO'
    }
    section = Section.new(invalid_attributes)
    section.save.should be_false
  end
  
  it "should not create a new instance withtout a video paper" do
    invalid_attributes = {
      :title=> "this is an awesome title.",
      :video_start_time => '25',
      :video_stop_time => '35',
      :content => 'IM SUCH AWESOME CONTENT BRO'      
    }
    section = Section.new(invalid_attributes)
    section.save.should be_false
  end
  
  it "should create a new instance without content" do
    valid_attributes = {
      :title=> "awesome start title",
      :video_paper_id => @video_paper.id,
      :video_start_time => '15',
      :video_stop_time => '18'
    }
    section = Section.new(valid_attributes)
    section.save.should be_true
  end
  
  it "should create a new instance without a start time" do
    valid_attributes = {
      :title=> "awesome start title",
      :video_paper_id => @video_paper.id,
      :content=> 'AWESOME FREAKIN CONTENT',
      :video_stop_time => '18'
    }
    
    section = Section.new(valid_attributes)
    section.save.should be_true
  end
  
  it "should create a new instance without a stop time" do
    valid_attributes = {
      :title=> "awesome start title",
      :video_paper_id => @video_paper.id,
      :content=> 'AWESOME FREAKIN CONTENT',
      :video_start_time => '18'
    }
    
    section = Section.new(valid_attributes)
    section.save.should be_true
  end
  
  it "should only allow a blank start/stop time" do
    valid_attributes = {
      :title=> "awesome start title",
      :video_paper_id => @video_paper.id,
      :content=> 'AWESOME FREAKIN CONTENT',
      :video_start_time => '',
      :video_stop_time => ''
    }
    
    section = Section.new(valid_attributes)
    section.save.should be_true
  end
  
  it "shouldn't allow a character start time" do
    invalid_attributes = {
      :title=> "awesome title",
      :video_paper_id=> @video_paper.id,
      :content=> 'AWESOME FREAKIN CONTENT',
      :video_start_time=> 'waffles',
      :video_stop_time => '15'
    }
    section = Section.new(invalid_attributes)
    section.save.should be_false
  end
  
  it "shouldn't allow a character stop time" do
    invalid_attributes = {
      :title=> "awesome title",
      :video_paper_id=> @video_paper.id,
      :content=> 'AWESOME FREAKIN CONTENT',
      :video_start_time=> '6',
      :video_stop_time=> 'waffles'
    }
    section = Section.new(invalid_attributes)
    section.save.should be_false
  end
  
  it "should allow a start time in hh:mm:ss format" do
    valid_attributes = {
      :title=> "awesome title",
      :video_paper_id=> @video_paper.id,
      :content=> 'AWESOME FREAKIN CONTENT',
      :video_start_time=> '00:00:01',
      :video_stop_time => '15'
    }
    section = Section.new(valid_attributes)
    section.save.should be_true    
    section.video_start_time.should == 1
  end
  
  it "should allow a stop time in hh:mm:ss format" do
    valid_attributes = {
      :title=> "awesome title",
      :video_paper_id=> @video_paper.id,
      :content=> 'AWESOME FREAKIN CONTENT',
      :video_stop_time=> '00:00:18',
      :video_start_time => '15'
    }
    section = Section.new(valid_attributes)
    section.save.should be_true   
    section.video_stop_time.should == 18 
  end
  
  it "shouldn't allow an invalid hh:mm:ss time" do
    invalid_attributes = {
      :title=> "awesome title",
      :video_paper_id=> @video_paper.id,
      :content=> 'AWESOME FREAKIN CONTENT',
      :video_stop_time=> '00:00:65',
      :video_start_time => '15'
    }
    section = Section.new(invalid_attributes)
    section.save.should be_false   
    
    invalid_attributes[:video_stop_time] = '00:75:00'
    section = Section.new(invalid_attributes)
    section.save.should be_false    
    
    invalid_attributes[:video_stop_time] = '25:00:00'
    section = Section.new(invalid_attributes)
    section.save.should be_false
  end 
  
  it "shouldn't allow an entered stop time to be greater than the start time" do
      invalid_attributes = {
        :title=> "awesome title",
        :video_paper_id=> @video_paper.id,
        :content=> 'AWESOME FREAKIN CONTENT',
        :video_stop_time=> '00:00:05',
        :video_start_time => '15'
      }
      section = Section.new(invalid_attributes)
      section.save.should be_false   
  end
  
  it "should set the video start time to the video's duration - 1 second if the start time is too large" do
    duration = @video.duration
    invalid_attributes = {
      :title=> "awesome title",
      :video_paper_id=> @video_paper.id,
      :content=> 'AWESOME FREAKIN CONTENT',
      :video_stop_time=> (duration.to_i + 21),
      :video_start_time => (duration.to_i + 20)
    }
    section = Section.new(invalid_attributes)
    section.save.should be_true
    section.video_start_time.should  == (duration.to_i - 1)
  end
  
  it "should set the video stop time to the video's duration if the stop time is too large" do
    duration = @video.duration
    invalid_attributes = {
      :title=> "awesome title",
      :video_paper_id=> @video_paper.id,
      :content=> 'AWESOME FREAKIN CONTENT',
      :video_stop_time=> (duration.to_i + 21),
      :video_start_time => (duration.to_i + 20)
    }
    section = Section.new(invalid_attributes)
    section.save.should be_true
    section.video_stop_time.should  == duration.to_i
  end
  
  it "should provide a reasonable timestamp formatted when given a time less than a minute" do
    section = Section.new(@valid_attributes)
    
    section.save.should be_true
    
    section.to_timestamp("22").should == "00:00:22"
    section.to_timestamp(15).should == "00:00:15"
  end
  
  it "should provide a reasonable timestamp formatted when given a time between a minute and an hour" do
    section = Section.new(@valid_attributes)
    
    section.save.should be_true
    
    section.to_timestamp("60").should == "00:01:00"
    section.to_timestamp(61).should == "00:01:01"
    section.to_timestamp(2053).should == "00:34:13"
    section.to_timestamp("3599").should == "00:59:59"
  end
  
  it "should provide a reasonable timestamp formatted when given a time greater than an hour" do
    section = Section.new(@valid_attributes)
    
    section.save.should be_true
    
    section.to_timestamp("3600").should == "01:00:00"
    section.to_timestamp("362624").should == "100:43:44"
  end
  
  it "shouldn't allow you to save a negative start/stop time" do
    invalid_attributes = {
      :title=> "awesome title",
      :video_paper_id=> @video_paper.id,
      :content=> 'AWESOME FREAKIN CONTENT',
      :video_stop_time=> '00:00:18',
      :video_start_time => '15'
    }
    section = Section.new(invalid_attributes)
    section.save.should be_true   
    
    invalid_attributes[:video_start_time] = '-12'
    section = Section.new(invalid_attributes)
    section.save.should be_false    
  end
end