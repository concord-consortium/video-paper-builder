require "spec_helper"

describe RegistrationsController do

  before(:each) do
    @old_mapping = @request.env["devise.mapping"]
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  after(:each) do
    @request.env["devise.mapping"] = @old_mapping
  end

  it "should redirect to root on new" do
    get :new
    expect(response.status).to eq 302
    expect(response).to redirect_to root_path()
  end

  it "should redirect to root on create" do
    post :create
    expect(response.status).to eq 302
    expect(response).to redirect_to root_path()
  end
end