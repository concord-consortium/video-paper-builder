require 'spec_helper'

describe VideoPaper do
  before(:each) do
    @valid_attributes = {
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    VideoPaper.create!(@valid_attributes)
  end
  
  it "should have a title" do 
    video = VideoPaper.new
    video.save.should be_false
  end
  
end
