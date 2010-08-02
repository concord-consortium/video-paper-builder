require 'spec_helper'

describe VideoPaper do
  before(:all) do
    @user = Factory.create(:user, :email=>"spec_test@velir.com")
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
  
  it "should have five sections" do
    video_paper = VideoPaper.new(:title=>"I have sections", :owner_id=> 1)
    video_paper.save!
    video_paper.sections.count.should equal 5
  end
  
end
