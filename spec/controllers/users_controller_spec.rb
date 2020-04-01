require "spec_helper"

describe UsersController do

  before(:each) do
    @user = FactoryBot.create(:admin)
    @user2 = FactoryBot.create(:user)
    @user3 = FactoryBot.create(:user)
    sign_in @user
  end

  it "should support destroy" do
    delete :destroy, params: { :id => @user2.id }
    expect(response.status).to eq 302
    expect(response).to redirect_to admins_path()
  end

  it "should support index" do
    # add a paper to test user comma (csv format) path
    paper = FactoryBot.create(:video_paper, :title => "Video1", :status => "unpublished", :user => @user2)
    video = FactoryBot.create(:video, :video_paper => paper)
    section = FactoryBot.create(:section, :title => "Section1", :video_paper => paper)
    shared_paper = FactoryBot.create(:shared_paper, :user => @user3, :video_paper => paper);

    get :index, format: :csv
    lines = response.body.split("\n")
    expect(response.status).to eq 200
    expect(lines.length).to be >= 2
    expect(lines[0]).to eq "Id,First Sign In,Most Recent Sign In,Number of Sign Ins,Initial Sign In Provider,First name,Last name,Email,Number of Papers,Last Paper: Title,Last Paper: Video Length,Last Paper: Last Text Edit,Last Paper: Number of Shares"
  end

  it "should support edit" do
    get :edit, params: { :id => @user2.id }
    expect(response.status).to eq 200
    expect(response).to render_template(:edit)
  end

  it "should support update with valid params" do
    post :update, params: { :id => @user2.id, :user => {:first_name => "foo"} }
    expect(response.status).to eq 302
    expect(response).to redirect_to admin_console_path()
  end

  it "should support update with invalid params" do
    post :update, params: { :id => @user2.id, :user => {:first_name => ""} }
    expect(response.status).to eq 200
    expect(response).to render_template(:edit)
  end

end