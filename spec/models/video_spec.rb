require 'spec_helper'

describe Video do
  fixtures :languages
  
  before(:all) do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin)    
    
    #find a video with the category of "test" to eff with.
    #if this fails you need to make add the test category and add a video to it on the kaltura server
    KalturaFu.generate_session_key
    temp_filter = Kaltura::Filter::BaseFilter.new
    pager = Kaltura::FilterPager.new
    pager.page_size = 100000
    test_video = KalturaFu.client.media_service.list(temp_filter,pager).objects.map!{|c| c if c.categories == "test"}.compact!.last
    test_video.should_not be_nil
    @entry = test_video.id
  end
  before(:each) do
    @valid_attributes = {
      :entry_id => @entry,
      :description => "value for description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private=> false
    }
  end

  it "should create a new instance given valid attributes" do
    video =Video.new(@valid_attributes)
    video.save.should be_true
  end
  
  it "should require a kaltura entry" do
    invalid_attributes = {
      :description=>@entry,
      :video_paper_id=>1,
      :language_id => Language.find_by_code('en').id,
      :private=>true      
    }
    video = Video.new(invalid_attributes)
    video.save.should be_false
  end
  it "should only have one video per video paper" do
    first_video = Video.new(@valid_attributes)
    first_video.save.should be_true
    
    second_video = Video.new(@valid_attributes)
    second_video.save.should be_false
  end

  it "should have a language" do
    invalid_attributes = {
      :entry_id => @entry,
      :description=> 'blarg',
      :video_paper_id => 1,
      :private=>true
    }
    
    video = Video.new(invalid_attributes)
    video.save.should be_false
    
  end
  
  it "should add the description to the Kaltura metadata" do
    description = rand(100).to_s + "waffles yo."
    valid_attributes = {
      :entry_id => @entry,
      :description => description,
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private=>false
    }
    
    video = Video.new(valid_attributes)
    video.save.should be_true
    
    description.should == (KalturaFu.get_video_info(@entry).description)
  end
  
  it "should set the kaltura category to the rails environment" do
    #first eff with the kaltura category
    KalturaFu.set_category(@entry,"blarg")
    KalturaFu.get_video_info(@entry).categories.should == "blarg"
    
    video = Video.new(@valid_attributes)
    video.save.should be_true
    
    KalturaFu.get_video_info(video.entry_id).categories.should == "test"
  end
  
  it "should snag the video duration from kaltura after saving" do
    video = Video.new(@valid_attributes)
    video.save.should be_true
    
    video.duration.should == KalturaFu.get_video_info(video.entry_id).duration
  end
  
  it "should update the processing status from kaltura" do
    video = Video.new(@valid_attributes)
    video.save.should be_true
    
    video.processed?.should == true
  end
  
  it "should respond appropriately to public?" do
    video = Video.new(@valid_attributes)
    video.save.should be_true
    video.public?.should be_true
    
    valid_attributos = {
      :entry_id => @entry,
      :description => "value for description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private=> true      
    }
    video_2 = Video.new(valid_attributos)
    video_2.save.should be_true
    video_2.public?.should be_false
  end  
  
  it "should respond appropriately to private?" do
    video = Video.new(@valid_attributes)
    video.save.should be_true
    video.private?.should be_false
    
    valid_attributos = {
      :entry_id => @entry,
      :description => "value for description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private=> true      
    }
    video_2 = Video.new(valid_attributos)
    video_2.save.should be_true
    video_2.private?.should be_true
  end  
  
  it "should allow a nil thumbnail_time" do
    valid_attributes = {
      :entry_id => @entry,
      :description => "a valid description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private => false,
      :thumbnail_time => nil
    }
    video = Video.new(valid_attributes)
    video.save.should be_true
  end
  
  it "should allow a blank thumbnail_time" do
    valid_attributes = {
      :entry_id => @entry,
      :description => "a valid description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private => false,
      :thumbnail_time => ""
    }
    video = Video.new(valid_attributes)
    video.save.should be_true
  end
  
  it "should allow a basic, numeric thumbnail_time" do
    valid_attributes = {
      :entry_id => @entry,
      :description => "a valid description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private => false,
      :thumbnail_time => "150"
    }
    video = Video.new(valid_attributes)
    video.save.should be_true
    video.thumbnail_time.should == '150'
  end
  
  it "should allow a properly timecoded hh:mm:ss time format to save" do
    valid_attributes = {
      :entry_id => @entry,
      :description => "a valid description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private => false,
      :thumbnail_time => "00:02:30"
    }
    video = Video.new(valid_attributes)
    video.save.should be_true
    video.thumbnail_time.should == 150
  end
  
  it "shouldn't allow a non-numeric time format" do
    invalid_attributes = {
      :entry_id => @entry,
      :description => "a valid description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private => false,
      :thumbnail_time => "waffles"
    }
    video = Video.new(invalid_attributes)
    video.save.should be_false
  end
  
  it "shouldn't allow a non-numeric time format in hh:mm:ss either" do
    invalid_attributes = {
      :entry_id => @entry,
      :description => "a valid description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private => false,
      :thumbnail_time => "waffles:05:12"
    }
    video = Video.new(invalid_attributes)
    video.save.should be_false
  end  
  
  it "shouldn't allow a seconds over 60 in hh:mm:ss format" do
    invalid_attributes = {
      :entry_id => @entry,
      :description => "a valid description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private => false,
      :thumbnail_time => "00:00:61"
    }
    video = Video.new(invalid_attributes)
    video.save.should be_false
  end  
  
  it "shouldn't allow a minutes over 60 in hh:mm:ss format" do
    invalid_attributes = {
      :entry_id => @entry,
      :description => "a valid description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private => false,
      :thumbnail_time => "00:61:05"
    }
    video = Video.new(invalid_attributes)
    video.save.should be_false
  end
  
  it "shouldn't anything over a day long in hh:mm:ss format" do
    invalid_attributes = {
      :entry_id => @entry,
      :description => "a valid description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private => false,
      :thumbnail_time => "25:00:02"
    }
    video = Video.new(invalid_attributes)
    video.save.should be_false
  end

  it "should allow a timestamp just under one day" do
    valid_attributes = {
      :entry_id => @entry,
      :description => "a valid description",
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private => false,
      :thumbnail_time => "23:59:59"
    }
    video = Video.new(valid_attributes)
    video.save.should be_true
    video.thumbnail_time.should  == 86399
  end
  
end