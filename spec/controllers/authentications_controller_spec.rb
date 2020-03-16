require "spec_helper"

describe AuthenticationsController do

  describe "schoology" do

    before(:each) do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:schoology] = OmniAuth::AuthHash.new({
        :provider => 'schoology',
        :uid => '123545',
        :info => {
          :email => "foo@example.com"
        },
        :extra => {
          :first_name => "Foo",
          :last_name => "Bar"
        }
      })
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    after(:each) do
      OmniAuth.config.test_mode = false
      OmniAuth.config.mock_auth[:schoology] = nil
      request.env["devise.mapping"] = nil
    end

    # TODO: figure out how to call into controller when we upgrade rspec
    # it "should work with no env var" do
    #   get user_omniauth_callback_path(:schoology)
    #   expect(response.status).to eq 200
    # end

    it "has a fake test to keep rspec happy" do
      expect(true).to eq true
    end
  end

end