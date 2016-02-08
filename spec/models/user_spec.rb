require 'spec_helper'
require 'ostruct'

describe User do
  before(:each) do
    @admin = FactoryGirl.create(:admin)
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

  describe ".find_for_omniauth" do
    before(:each) do
      @oauth_user = FactoryGirl.create(:user, :provider => 'schoology', :uid => 1)
      @auth = OpenStruct.new({
        :provider => @oauth_user.provider,
        :uid => @oauth_user.uid,
        :info => OpenStruct.new({
          :email => @oauth_user.email
        }),
        :extra => OpenStruct.new({
          :first_name => @oauth_user.first_name,
          :last_name => @oauth_user.last_name
        })
      })
      @realm = FactoryGirl.create(:schoology_realm)
    end

    it "should not allow a oauth request from an unknown realm" do
      expect { User.find_for_omniauth(@auth, 'unknown_realm', 1) }.to raise_error(RuntimeError, "your unknown_realm does not have access to this application")
    end

    it "should allow an existing oauth user from a known realm" do
      user = User.find_for_omniauth(@auth, @realm.realm_type, @realm.schoology_id)
      user.id.should == @oauth_user.id
    end

    it "should allow a oauth login for an existing non-outh user" do
      non_oauth_user = FactoryGirl.create(:user)
      @auth.uid = 2
      @auth.info.email = non_oauth_user.email
      user = User.find_for_omniauth(@auth, @realm.realm_type, @realm.schoology_id)
      user.id.should == non_oauth_user.id
    end

    it "should not allow oauth login for an existing email with different uid" do
      other_oauth_user = FactoryGirl.create(:user, :provider => "schoology", :uid => 2)
      @auth.uid = 3
      @auth.info.email = other_oauth_user.email
      expect { User.find_for_omniauth(@auth) }.to raise_error(RuntimeError, "a user with that email from that provider already exists")
    end

    it "should not allow a oauth registration without a realm" do
      @auth.uid = 2
      @auth.info.email = 'newuser@example.com'
      expect { User.find_for_omniauth(@auth) }.to raise_error(RuntimeError, "you can only register for this application through an allowed course or group")
    end

    it "should not allow a oauth registration without a valid realm" do
      @auth.uid = 2
      @auth.info.email = 'newuser@example.com'
      expect { User.find_for_omniauth(@auth, 'unknown_realm', 1) }.to raise_error(RuntimeError, "your unknown_realm does not have access to this application")
    end

    it "should allow a oauth registration with a valid realm" do
      @auth.uid = 2
      @auth.info.email = 'newuser@example.com'
      user = User.find_for_omniauth(@auth, @realm.realm_type, @realm.schoology_id)
      user.uid.should == @auth.uid
      user.id.should > @oauth_user.id
    end
  end
end
