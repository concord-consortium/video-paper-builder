require 'spec_helper'

describe Section do

  before(:all) do
    @user  = Factory.create(:user, :email=>"spec_test1@velir.com")
    @video_paper = Factory.create(:video_paper, :owner_id => @user.id, :title => "valid title")
  end

  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :video_paper => @video_paper
    }
    @invalid_attributes = {
      :title => nil,
      :video_paper => nil
    }
    
  end
  
  it "should create a new instance given valid attributes" do
    section = Section.new(@valid_attributes)
    section.save!.should be_true
  end

  it "should not create a new instance given invalid attributes" do
    section = Section.new(@invalid_attributes)
    section.save.should be_false
  end

end