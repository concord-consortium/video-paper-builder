require 'spec_helper'

describe User do
  before(:all) do
    @admin = FactoryGirl.create(:admin)
  end
  before(:each) do
  end
  it "should require a first and last name for an admin account" do
    admin = Admin.new
    admin.email = "completely_random_email" + rand(100).to_s + "@velir.com"
    admin.password = "funstuff"
    admin.password_confirmation = "funstuff"
    
    admin.save.should be_false
    
    admin.first_name = "tim"
    admin.last_name = "bobbin"
    
    admin.save.should be_true    
  end
  
  it "should require a first and last name for a user account" do
    user = User.new
    user.email = "completely_random_email" + rand(100).to_s + "@velir.com"
    user.password = "funstuff"
    user.password_confirmation = "funstuff"
    
    user.save.should be_false
    user.first_name = "tim"
    user.last_name = "bobbin"
    
    user.save.should be_true
  end
  
  it "a user should return the full name when I ask for it" do
    user = FactoryGirl.create(:user,:first_name=>"lowercase",:last_name=>"name")
    
    user.name.should == "Lowercase Name"
  end
  
  it "an admin should return the full name when I ask for it" do
    admin = FactoryGirl.create(:admin,:first_name=>"lowERCase",:last_name=>"namE")
    
    admin.name.should == "Lowercase Name"
  end  
  
end
