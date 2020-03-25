require "spec_helper"

describe VideosController do
  before(:each) do
    @admin = FactoryGirl.create(:admin)
    @user = FactoryGirl.create(:user, :email => "foo@bar.com")
    @paper = FactoryGirl.create(:video_paper, :title => "Video1", :status => "unpublished", :user => @user);
    @video = FactoryGirl.create(:video, :video_paper => @paper)
    allow_any_instance_of(Video).to receive(:cancel_transcoding_job).and_return(nil)
    allow_any_instance_of(Video).to receive(:start_transcoding_job).and_return(nil)
    sign_in @user
  end

  it "should support index" do
    get :index, {:video_paper_id => @paper.id}
    expect(response.status).to eq 302
    expect(response).to redirect_to video_paper_path(@paper)
  end

  it "should redirect index without a video" do
    paper = FactoryGirl.create(:video_paper, :title => "Video2", :status => "unpublished", :user => @user);
    get :index, {:video_paper_id => paper.id}
    expect(response.status).to eq 302
    expect(response).to redirect_to new_video_paper_video_path(paper)
  end

  it "should redirect index when the user doesn't own the video" do
    user2 = FactoryGirl.create(:user, :email => "bing@bar.com")
    paper = FactoryGirl.create(:video_paper, :title => "Video2", :status => "unpublished", :user => user2);
    get :index, {:video_paper_id => paper.id}
    expect(response.status).to eq 302
    expect(response).to redirect_to root_path()
  end

  it "should support show for admins" do
    sign_in @admin
    get :show, {:video_paper_id => @paper.id, :id => @video.id}
    expect(response.status).to eq 200
    expect(response).to render_template(:show)
  end

  it "should redirect new if the video exists" do
    get :new, {:video_paper_id => @paper.id}
    expect(response.status).to eq 302
    expect(response).to redirect_to edit_video_paper_video_path(@paper, @video)
  end

  it "should support new if the video does not exist" do
    paper = FactoryGirl.create(:video_paper, :title => "Video2", :status => "unpublished", :user => @user);
    get :new, {:video_paper_id => paper.id}
    expect(response.status).to eq 200
    expect(response).to render_template(:new)
  end

  it "should support create for owners" do
    paper = FactoryGirl.create(:video_paper, :title => "Video2", :status => "unpublished", :user => @user);
    post :create, {:video_paper_id => paper.id, :video => {:upload_uri => "https://example.com/foo"}}
    expect(response.status).to eq 302
    expect(response).to redirect_to(video_paper_path(paper))
  end

  it "should not support create for owners with invalid params" do
    paper = FactoryGirl.create(:video_paper, :title => "Video2", :status => "unpublished", :user => @user);
    post :create, {:video_paper_id => paper.id, :video => {:upload_uri => nil}}
    expect(response.status).to eq 200
    expect(response).to render_template(:new)
  end

  it "should not support create for non-owners/admins" do
    user2 = FactoryGirl.create(:user, :email => "bing@bar.com")
    paper = FactoryGirl.create(:video_paper, :title => "Video2", :status => "unpublished", :user => user2);
    post :create, {:video_paper_id => paper.id, :video => {:upload_uri => "https://example.com/foo"}}
    expect(response.status).to eq 302
    expect(response).to redirect_to(root_path())
  end

  it "should support edit" do
    get :edit, {:video_paper_id => @paper.id, :id => @video.id}
    expect(response.status).to eq 200
    expect(response).to render_template(:edit)
  end

  it "should support update with invalid parameters" do
    post :update, {:video_paper_id => @paper.id, :id => @video.id, :video => {:upload_uri => nil}}
    expect(response.status).to eq 200
    expect(response).to render_template(:edit)
  end

  it "should support update with valid parameters" do
    post :update, {:video_paper_id => @paper.id, :id => @video.id, :video => {:upload_uri => "https://example.com/foo"}}
    expect(response.status).to eq 302
    expect(response).to redirect_to video_paper_path(@paper)
  end

  it "should support start_transcoding_job for admins" do
    sign_in @admin
    post :start_transcoding_job, {:video_paper_id => @paper.id, :id => @video.id}
    expect(response.status).to eq 302
    expect(response).to redirect_to video_paper_video_path(@paper, @video)
  end

end