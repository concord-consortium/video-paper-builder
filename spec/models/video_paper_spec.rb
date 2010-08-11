require 'spec_helper'

describe VideoPaper do
  before(:all) do
    @user = Factory.create(:user, :email=>"spec_test@velir.com")
    @second_user = Factory.create(:user,:email=>"super_spec_test@velir.com")
  end
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :owner_id => @user.id
    }
  end

  it "should create a new instance given valid attributes" do
    VideoPaper.create!(@valid_attributes)
  end
  
  it "should have a title" do 
    video_paper = VideoPaper.new(:owner_id=>@user.id)
    video_paper.save.should be_false
  end
  
  it "should require an owner_id" do 
    video_paper = VideoPaper.new(:title=>"This is a valid title")
    video_paper.save.should be_false
  end
  
  it "should belong to a user" do 
    user_video_paper = VideoPaper.new(:title=>"Awesome Title",
      :owner_id=>@user.id
    )
    user_video_paper.save    
    user_video_paper.user.should == @user
  end
  
  it "should have preset sections" do
    video_paper = VideoPaper.new(:title=>"I have sections", :owner_id=> 1)
    video_paper.save!
    Settings.sections.each do |section_setting|
      section = video_paper.sections.find_by_title(section_setting[1]["title"])
      section.should_not be nil
    end
    video_paper.sections.count.should equal Settings.sections.count
  end
  
  
  it "should let you share the paper to another user" do
    video_paper = Factory.create(:video_paper)
    
    share_attributes = {
      :user_id => @second_user.id,
      :notes=> "I love lamp"
    }
    video_paper.share(share_attributes).should be_true
    paper = video_paper.shared_papers.find_by_user_id(share_attributes[:user_id]) 
    video_paper.shared_papers.include?(paper).should be_true
  end
  
  it "shouldn't let you share the paper to the same user twice.  duplicates make kittens sad" do
    video_paper = Factory.create(:video_paper)
    
    share_attributes = {
      :user_id => @second_user.id,
      :notes => "waffles are great."
    }
    video_paper.share(share_attributes).should be_true
    paper = video_paper.shared_papers.find_by_user_id(share_attributes[:user_id]) 
    video_paper.shared_papers.include?(paper).should be_true
    
    share_attributes[:notes] = "well waffles aren't fantastic."
    video_paper.share(share_attributes).should be_false
    
    second_paper = video_paper.shared_papers.find_by_notes(share_attributes[:notes])
    video_paper.shared_papers.include?(second_paper).should be_false
  end
  
  it "should let you unshare the paper when need be." do 
    video_paper = Factory.create(:video_paper)
    
    share_attributes = {
      :user_id => @second_user.id,
      :notes=> "I love lamp"
    }
    video_paper.share(share_attributes).should be_true
    paper = video_paper.shared_papers.find_by_user_id(share_attributes[:user_id])    
    
    video_paper.shared_papers.include?(paper).should be_true
    
    video_paper.unshare(share_attributes[:user_id]).should be_true
    
    video_paper.shared_papers.include?(paper).should be_false
  end
  
  it "should indicate a share was unsuccesful when you give it poor attributes" do
    video_paper = Factory.create(:video_paper)
    
    share_attributes = {
      :user_id => 'I am not right at all',
      :notes => 'ditto.'
    }
    
    video_paper.share(share_attributes).should be_false
    paper = video_paper.shared_papers.find_by_user_id(share_attributes[:user_id])
    #video_paper.shared_papers.include?(paper).should be_false
  end
  
  it "should produce a human readable created by date" do
    video_paper = Factory.create(:video_paper)
    
    pretty_date = Time.now.utc
    pretty_date = pretty_date.strftime("%A %B #{pretty_date.day.ordinalize}, %Y")
    
    video_paper.format_created_date.should == pretty_date
    
  end
  
  it "should default to unpublished when a new video paper is created" do
    video_paper = VideoPaper.new(@valid_attributes)
    video_paper.save.should be_true
    
    video_paper.published?.should be_false
    video_paper.unpublished?.should be_true
    video_paper.status.should == 'unpublished'
  end
  
  it "should display as published when published! is called" do
    video_paper = VideoPaper.new(@valid_attributes)
    video_paper.save.should be_true
    
    video_paper.publish!
    video_paper.published?.should be_true
    video_paper.unpublished?.should be_false
    video_paper.status.should == 'published'
  end
  
  it "should display as unpublished when unpublish! is called" do
    video_paper = VideoPaper.new(@valid_attributes)
    video_paper.save.should be_true
    
    video_paper.publish!
    video_paper.unpublish!
    video_paper.published?.should be_false
    video_paper.unpublished?.should be_true
    video_paper.status.should == 'unpublished'
  end
end
