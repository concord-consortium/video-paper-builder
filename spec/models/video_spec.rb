require 'spec_helper'

describe Video do
  before(:all) do
    @user1 = Factory.create(:user)
    @user2 = Factory.create(:user)
    @admin = Factory.create(:admin)    
    
    #find a video with the category of "test" to eff with.
    KalturaFu.generate_session_key
    temp_filter = Kaltura::Filter::BaseFilter.new
    pager = Kaltura::FilterPager.new
    pager.page_size = 100000
    @entry = KalturaFu.client.media_service.list(temp_filter,pager).objects.map!{|c| c if c.categories == "test"}.compact!.last.id
  end
  before(:each) do
    @valid_attributes = {
      :entry_id => @entry,
      :description => "value for description",
      :video_paper_id => Factory.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private=> false
    }
  end

  it "should create a new instance given valid attributes" do
    video =Video.new(@valid_attributes)
    video.save.should be_true
  end
  
  it "should require a description" do 
    invalid_attributes = {
      :entry_id => @entry,
      :video_paper_id => 1,
      :language_id => Language.find_by_code('en').id,
      :private=>true
    }
    video = Video.new(invalid_attributes)
    
    video.save.should be_false
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
  it "should limit the description to 500 characters" do
    invalid_attributes = {
      :entry_id=>@entry,
      :description=> "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur nisi justo, iaculis quis dapibus vitae, egestas non erat. Donec pretium rhoncus iaculis. Integer tempus dui sit amet elit auctor at elementum justo interdum. Ut pulvinar congue magna placerat pulvinar. Phasellus eget mauris arcu, ut lacinia purus. Pellentesque in ipsum tempor felis sollicitudin egestas. Proin consequat facilisis nulla id lobortis. Donec quis egestas erat. Cras porta, tortor sed feugiat facilisis, augue massa ultricies tellus, vitae viverra quam ligula id velit. Praesent libero lorem, mattis non vulputate quis, porta ut massa. Nunc at felis at libero rhoncus ultrices. Morbi non lorem tellus, non pellentesque urna. Sed non dui tortor, vitae varius lectus. Nullam facilisis lorem non ante facilisis luctus. Praesent auctor mollis ipsum, id sollicitudin mauris mollis at. In hac habitasse platea dictumst.

      Donec odio nibh, fringilla a pharetra in, cursus et nibh. Nulla eu feugiat ligula. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam vulputate congue tempor. Donec vel nunc quam. Fusce sit amet felis et nibh egestas pretium vel in nisi. Ut neque quam, venenatis nec pretium eu, sagittis non diam. Vivamus non mauris quam. Quisque id quam massa, eget tempor dui. Aenean mollis accumsan cursus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec auctor volutpat urna, nec ornare orci adipiscing sit amet. Vivamus interdum velit quis nulla fermentum elementum. Phasellus et nulla elit, tempus molestie neque. Pellentesque non sapien tortor. In hac habitasse platea dictumst. Curabitur gravida eros quis neque tristique ut tincidunt dui lobortis. Quisque eget nulla ante. Vestibulum adipiscing tellus et urna feugiat dictum. Pellentesque convallis vulputate nulla et dictum.

      Nullam eget hendrerit lorem. Mauris faucibus vulputate convallis. Nulla ullamcorper tincidunt nisi, et luctus massa vestibulum quis. Curabitur egestas pellentesque sollicitudin. Sed sit amet lacus libero. Vivamus at nisi augue, ac pharetra magna. Donec commodo adipiscing nibh ut sagittis. Aenean neque tellus, tempus eu tempor vitae, auctor at nulla. Donec orci velit, sollicitudin sed tincidunt non, sollicitudin ac erat. Maecenas lorem est, porta id posuere eget, iaculis ut eros. Nulla velit lacus, hendrerit lacinia euismod in, malesuada sit amet nisi. Duis id dapibus sem. Nunc convallis gravida mi, sit amet eleifend erat laoreet sodales. Curabitur dapibus commodo nisi, ut scelerisque elit aliquet eu. Cras porta suscipit tortor, eu dapibus nulla condimentum vitae.

      Maecenas lorem ipsum, faucibus ut laoreet hendrerit, aliquet nec dui. Vivamus tempor lacus ut tortor consectetur vitae ullamcorper lorem ultricies. Maecenas tempor laoreet tincidunt. Pellentesque gravida ligula mattis enim volutpat nec condimentum lectus ullamcorper. In lobortis metus nec nulla convallis auctor. In vel mi risus. Sed vel augue hendrerit dui mollis semper sed quis lorem. Phasellus vel arcu nibh. Donec pharetra, orci at dictum semper, metus metus molestie lorem, ac ultrices urna metus ut tortor. Cras auctor lectus vitae velit tempus ac tincidunt elit rhoncus. Duis tempus posuere eros, sed vehicula neque condimentum eget. Fusce imperdiet leo eu ligula luctus consectetur. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

      Pellentesque tincidunt dui sed leo lacinia suscipit. Curabitur dapibus sollicitudin mollis. Sed ac lorem eget tellus vehicula suscipit sed vel tellus. Praesent orci quam, dignissim id iaculis sit amet, dictum nec lacus. In placerat leo nec lacus pharetra ac tincidunt turpis imperdiet. Donec vehicula faucibus sem ac iaculis. Nullam at sem orci, sit amet consectetur enim. Praesent euismod porttitor nisi tincidunt dictum. Vivamus dictum nisl eu mauris scelerisque pretium a vel mauris. Nunc arcu mauris, tincidunt a vestibulum id, lobortis vel nunc. Etiam aliquam, quam id rutrum cursus, lacus sem sollicitudin sapien, at placerat diam orci at quam. Morbi venenatis lacus at ipsum pharetra aliquam. In vel arcu nibh. Nunc vitae urna quam. Duis id sapien risus, nec ornare enim. Sed blandit lorem sit amet leo mollis dictum. Aliquam urna ante, tincidunt eget hendrerit nec, commodo vitae massa.",
      :video_paper_id=>1,
      :language_id => Language.find_by_code('en').id,
      :private=>true      
    }
    
    video = Video.new(invalid_attributes)
    video.save.should be_false
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
      :video_paper_id => 1,
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
      :video_paper_id => Factory.create(:video_paper).id,
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
      :video_paper_id => Factory.create(:video_paper).id,
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
      :video_paper_id => Factory.create(:video_paper).id,
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
      :video_paper_id => Factory.create(:video_paper).id,
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
      :video_paper_id => Factory.create(:video_paper).id,
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
      :video_paper_id => Factory.create(:video_paper).id,
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
      :video_paper_id => Factory.create(:video_paper).id,
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
      :video_paper_id => Factory.create(:video_paper).id,
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
      :video_paper_id => Factory.create(:video_paper).id,
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
      :video_paper_id => Factory.create(:video_paper).id,
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
      :video_paper_id => Factory.create(:video_paper).id,
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
      :video_paper_id => Factory.create(:video_paper).id,
      :language_id => Language.find_by_code('en').id,
      :private => false,
      :thumbnail_time => "23:59:59"
    }
    video = Video.new(valid_attributes)
    video.save.should be_true
    video.thumbnail_time.should  == 11879
  end
  
end