require 'spec_helper'

describe SharedPaper do
  before(:each) do
    @valid_attributes = {
      :video_paper_id => Factory.create(:video_paper).id,
      :user_id => Factory.create(:user).id,
      :notes=>"I like beets."
    }
  end

  it "should create a new instance given valid attributes" do
    paper = SharedPaper.new(@valid_attributes)
    paper.save.should be_true
  end
  
  it "shouldn't require a note" do
    valid_attributes = {
      :video_paper_id => Factory.create(:video_paper).id,
      :user_id => Factory.create(:user).id
    }
    
    paper = SharedPaper.new(valid_attributes)
    paper.save.should be_true
  end
  
  it "should require a paper ID" do
    invalid_attributes = {
      :user_id => Factory.create(:user).id,
      :notes=>"I will not work yo."
    }
    
    paper = SharedPaper.new(invalid_attributes)
    paper.save.should be_false
  end
  
  it "should require a user ID" do
    invalid_attributes = {
      :video_paper_id => Factory.create(:video_paper).id,
      :notes => "This will not work either."
    }
    paper = SharedPaper.new(invalid_attributes)
    paper.save.should be_false
  end
end
