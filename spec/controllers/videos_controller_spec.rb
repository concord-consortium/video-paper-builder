require "spec_helper"

describe VideosController do
  before(:each) do
    @admin = FactoryBot.create(:admin)
    @user = FactoryBot.create(:user, :email => "foo@bar.com")
    @paper = FactoryBot.create(:video_paper, :title => "Video1", :status => "unpublished", :user => @user);
    @video = FactoryBot.create(:video, :video_paper => @paper)
    allow_any_instance_of(Video).to receive(:cancel_transcoding_job).and_return(nil)
    allow_any_instance_of(Video).to receive(:start_transcoding_job).and_return(nil)
    sign_in @user
  end

  it "should support index" do
    get :index, params: { :video_paper_id => @paper.id }
    expect(response.status).to eq 302
    expect(response).to redirect_to video_paper_path(@paper)
  end

  it "should redirect index without a video" do
    paper = FactoryBot.create(:video_paper, :title => "Video2", :status => "unpublished", :user => @user);
    get :index, params: { :video_paper_id => paper.id }
    expect(response.status).to eq 302
    expect(response).to redirect_to new_video_paper_video_path(paper)
  end

  it "should redirect index when the user doesn't own the video" do
    user2 = FactoryBot.create(:user, :email => "bing@bar.com")
    paper = FactoryBot.create(:video_paper, :title => "Video2", :status => "unpublished", :user => user2);
    get :index, params: { :video_paper_id => paper.id }
    expect(response.status).to eq 302
    expect(response).to redirect_to root_path()
  end

  it "should support show for admins" do
    sign_in @admin
    get :show, params: { :video_paper_id => @paper.id, :id => @video.id }
    expect(response.status).to eq 200
    expect(response).to render_template(:show)
  end

  it "should redirect new if the video exists" do
    get :new, params: { :video_paper_id => @paper.id }
    expect(response.status).to eq 302
    expect(response).to redirect_to edit_video_paper_video_path(@paper, @video)
  end

  it "should support new if the video does not exist" do
    paper = FactoryBot.create(:video_paper, :title => "Video2", :status => "unpublished", :user => @user);
    get :new, params: { :video_paper_id => paper.id }
    expect(response.status).to eq 200
    expect(response).to render_template(:new)
  end

  it "should support create for owners" do
    paper = FactoryBot.create(:video_paper, :title => "Video2", :status => "unpublished", :user => @user);
    post :create, params: { :video_paper_id => paper.id, :video => {:upload_uri => "https://example.com/foo"} }
    expect(response.status).to eq 302
    expect(response).to redirect_to(video_paper_path(paper))
  end

  it "should not support create for owners with invalid params" do
    paper = FactoryBot.create(:video_paper, :title => "Video2", :status => "unpublished", :user => @user);
    post :create, params: { :video_paper_id => paper.id, :video => {:upload_uri => nil} }
    expect(response.status).to eq 200
    expect(response).to render_template(:new)
  end

  it "should not support create for non-owners/admins" do
    user2 = FactoryBot.create(:user, :email => "bing@bar.com")
    paper = FactoryBot.create(:video_paper, :title => "Video2", :status => "unpublished", :user => user2);
    post :create, params: { :video_paper_id => paper.id, :video => {:upload_uri => "https://example.com/foo"} }
    expect(response.status).to eq 302
    expect(response).to redirect_to(root_path())
  end

  it "should support edit" do
    get :edit, params: { :video_paper_id => @paper.id, :id => @video.id }
    expect(response.status).to eq 200
    expect(response).to render_template(:edit)
  end

  it "should support update with invalid parameters" do
    post :update, params: { :video_paper_id => @paper.id, :id => @video.id, :video => {:upload_uri => nil} }
    expect(response.status).to eq 200
    expect(response).to render_template(:edit)
  end

  it "should support update with valid parameters" do
    post :update, params: { :video_paper_id => @paper.id, :id => @video.id, :video => {:upload_uri => "https://example.com/foo"} }
    expect(response.status).to eq 302
    expect(response).to redirect_to video_paper_path(@paper)
  end

  it "should support start_transcoding_job for admins" do
    sign_in @admin
    post :start_transcoding_job, params: { :video_paper_id => @paper.id, :id => @video.id }
    expect(response.status).to eq 302
    expect(response).to redirect_to video_paper_video_path(@paper, @video)
  end

end