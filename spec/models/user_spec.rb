require 'spec_helper'
require 'ostruct'
require 'omni_auth/strategies/schoology'

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
    let (:in_authorized_realm) { true }

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
          :last_name => @oauth_user.last_name,
          :in_authorized_realm? => in_authorized_realm
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

    describe "in unauthorized realms" do
      let (:in_authorized_realm) { false }

      it "should not allow a oauth registration without a realm" do
        @auth.uid = 2
        @auth.info.email = 'newuser@example.com'
        expect { User.find_for_omniauth(@auth) }.to raise_error(RuntimeError, "you are not part of a class or group that has access to this application")
      end

      it "should not allow a oauth registration without a valid realm" do
        @auth.uid = 2
        @auth.info.email = 'newuser@example.com'
        expect { User.find_for_omniauth(@auth, 'unknown_realm', 1) }.to raise_error(RuntimeError, "your unknown_realm does not have access to this application")
      end
    end

    it "should allow a oauth registration with a valid realm" do
      @auth.uid = 2
      @auth.info.email = 'newuser@example.com'
      user = User.find_for_omniauth(@auth, @realm.realm_type, @realm.schoology_id)
      user.uid.should == @auth.uid
      user.id.should > @oauth_user.id
    end
  end

  it "should support generate_reset_password_token!" do
    user = FactoryGirl.create(:user)
    expect(user.generate_reset_password_token!()).not_to be nil
  end

  it "should call add_common_shared_paper after create" do
    user = FactoryGirl.create(:user)
    paper = FactoryGirl.create(:video_paper, :title => "Video1", :status => "unpublished", :user => user)
    expect(paper.users).to have(0).record

    ENV["COMMON_SHARED_PAPER_ID"] = "#{paper.id}"
    user2 = FactoryGirl.create(:user)
    ENV.delete("COMMON_SHARED_PAPER_ID")

    paper.reload
    expect(paper.users).to have(1).record
    expect(paper.users).to eq [user2]
  end

  # TODO: fix @schoology.access_token.stub when rspec is upgraded
  # describe "Schoology OmniAuth strategy" do
  #   before(:each) do
  #     @schoology = OmniAuth::Strategies::Schoology.new(nil)
  #     # stubbing this now causes a runtime error in ruby 2.2 (can't modify frozen NilClass)
  #     @schoology.access_token.stub(:get) do |url|
  #       case url
  #       when "/v1/users/me"
  #         OpenStruct.new({
  #           :body => {
  #             "uid" => 1,
  #             "primary_email" => "foo@example.com",
  #             "name_first" => "Foo",
  #             "name_last" => "Bar",
  #           }.to_json
  #         })
  #       when "/v1/groups/1/enrollments?uid=1"
  #         OpenStruct.new({
  #           :code => "200",
  #           :body => {
  #             "enrollment" => {
  #               "count" => 1
  #             },
  #           }.to_json
  #         })
  #       else
  #         nil
  #       end
  #     end
  #   end
  #
  #   it "supports raw_info with no schoology realms" do
  #     expect(@schoology.uid).to eq 1
  #     expect(@schoology.extra[:first_name]).to eq "Foo"
  #     expect(@schoology.extra[:last_name]).to eq "Bar"
  #     expect(@schoology.extra[:in_authorized_realm?]).to eq false
  #   end
  #
  #   it "supports raw_info with schoology realms" do
  #     realm = FactoryGirl.build(:schoology_realm, :realm_type => 'group', :schoology_id => @schoology.uid)
  #     realm.save
  #     expect(@schoology.extra[:in_authorized_realm?]).to eq true
  #   end
  # end
end
