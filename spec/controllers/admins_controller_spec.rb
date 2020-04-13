require "spec_helper"

describe AdminsController do

  before(:each) do
    @admin = FactoryBot.create(:admin)
    @admin2 = FactoryBot.create(:admin)
    @user = FactoryBot.create(:user)
    sign_in @admin
  end

  it "should support destroy" do
    delete :destroy, params: { :id => @admin2.id }
    expect(response.status).to eq 302
    expect(response).to redirect_to admins_path()
  end

  it "should support index" do
    get :index
    expect(response.status).to eq 200
  end

  it "should support accept_user_invitation" do
    patch :accept_user_invitation, params: {:user => {:id => @user.id }}
    expect(response.status).to eq 302
    expect(response).to redirect_to admin_console_url()
  end

end