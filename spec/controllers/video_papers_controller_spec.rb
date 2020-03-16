require "spec_helper"

describe VideoPapersController do

  # override authenticate_user! devise method
  # controller do
  #   def authenticate_user!
  #     # devise method called by VideoPapersController#authenticate_shared!
  #     true
  #   end
  # end

  before(:each) do
    @admin = FactoryGirl.create(:admin)
    @user = FactoryGirl.create(:user)
    @paper = FactoryGirl.create(:video_paper, :title => "Video1", :status => "unpublished", :user => @user)
  end

  describe "admins" do
    before(:each) do
      sign_in @admin
    end

    it "should support index by user" do
      get :index, {:user => @user.id}
      expect(assigns(:video_papers)).not_to be_nil
      expect(response).to render_template(:index)
    end

    it "should support report without users" do
      get :report
      expect(response.status).to eq(200)
    end

    it "should support report with users" do
      user2 = FactoryGirl.create(:user)
      shared_paper = FactoryGirl.create(:shared_paper, :user => user2, :video_paper => @paper);
      get :report
      expect(response.status).to eq(200)
    end

    it "should support show" do
      get :show, {:id => @paper.id}
      expect(response.status).to eq 200
      expect(response).to render_template(:show)
    end

    it "should support edit_section" do
      get :edit_section, {:id => @paper.id}
      expect(response.status).to eq(200)
      expect(response).to render_template(:edit_section)
    end
  end

  describe "non-admin users" do
    before(:each) do
      sign_in @user
    end

    it "should not support index by user" do
      get :index, {:user => @user.id}
      expect(response.status).to eq 302
      expect(response).to redirect_to new_admin_session_path()
    end

    it "should support my_video_papers" do
      get :my_video_papers
      expect(assigns(:video_papers)).to eq [@paper]
      expect(response.status).to eq(200)
    end

    it "should support create without params" do
      get :create
      expect(response.status).to eq 200
      expect(response).to render_template(:new)
    end

    it "should support create with params" do
      get :create, {:video_paper => {:title => "Video1"}, :commit => "Upload a video"}
      expect(response.status).to eq 302
      expect(response).to redirect_to new_video_paper_video_path(assigns(:video_paper))
    end

    describe "should support show" do

      it "if user is owner" do
        get :show, {:id => @paper.id}
        expect(response.status).to eq 200
        expect(response).to render_template(:show)
      end

      it "user is not owner or admin" do
        user2 = FactoryGirl.create(:user)
        sign_in user2
        get :show, {:id => @paper.id}
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path()
      end

      it "but redirect if not published" do
        user2 = FactoryGirl.create(:user)
        paper2 = FactoryGirl.create(:video_paper, :title => "Video1", :status => "unpublished", :user => user2);
        get :show, {:id => paper2.id}
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path()
      end

      it "but redirect to signin if not owner" do
        user2 = FactoryGirl.create(:user)
        paper2 = FactoryGirl.create(:video_paper, :title => "Video1", :status => "published", :user => user2);
        get :show, {:id => paper2.id}
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path()
      end

      it "when not logged in it should fail" do
        sign_out @user
        get :show, {:id => @paper.id}
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path()
      end
    end

    describe "should support update" do

      it "but redirect to edit on empty title" do
        post :update, {:id => @paper.id, :video_paper => {:title => ""}}
        expect(response.status).to eq 200
        expect(response).to render_template(:edit)
      end

      describe "with commit of" do
        it "Enter in notes" do
          post :update, {:id => @paper.id, :video_paper => {:title => "Video2"}, :commit => "Enter in notes"}
          expect(response.status).to eq 302
          expect(response).to redirect_to video_paper_path(@paper)
        end

        it "Upload a video" do
          post :update, {:id => @paper.id, :video_paper => {:title => "Video2"}, :commit => "Upload a video"}
          expect(response.status).to eq 302
          expect(response).to redirect_to new_video_paper_video_path(@paper)
        end

        it "Change video" do
          video = FactoryGirl.create(:video, :video_paper => @paper)
          post :update, {:id => @paper.id, :video_paper => {:title => "Video2"}, :commit => "Change video"}
          expect(response.status).to eq 302
          expect(response).to redirect_to edit_video_paper_video_path(@paper, video)
        end

        it "invalid value" do
          post :update, {:id => @paper.id, :video_paper => {:title => "Video2"}, :commit => "invalid value"}
          expect(response.status).to eq 200
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "should support update_section" do
      before(:each) do
        @video = FactoryGirl.create(:video, :video_paper => @paper)
        @section = FactoryGirl.create(:section, :title => "Section1", :video_paper => @paper)
      end

      it "without commit params" do
        get :update_section, {:id => @paper.id, :section => {:title => "Section1", :content => "foo"}}
        expect(response.status).to eq 302
        expect(response).to redirect_to "#{video_paper_path(@paper)}#section1"
      end

      it "with commit params" do
        get :update_section, {:id => @paper.id, :section => {:title => "Section1", :content => "foo"}, :commit => "Edit Timing"}
        expect(response.status).to eq 302
        expect(response).to redirect_to edit_section_duration_video_paper_path(@paper, {:section => @section.title})
      end
    end

    describe "should support unshare without it being shared" do
      before(:each) do
        @user2 = FactoryGirl.create(:user)
      end

      it "should not fail in html" do
        get :unshare, {:id => @paper.id, :user_id => @user2.id}
        expect(response.status).to eq 302
        expect(response).to redirect_to share_video_paper_path(@paper)
      end

      it "should not fail in js" do
        xhr :get, :unshare, {:id => @paper.id, :user_id => @user2.id}
        expect(response.status).to eq 302
        expect(response).to redirect_to share_video_paper_path(@paper)
      end
    end

    describe "should support unshare with it being shared" do
      before(:each) do
        @user2 = FactoryGirl.create(:user)
        @shared_paper = FactoryGirl.create(:shared_paper, :user => @user2, :video_paper => @paper);
      end

      it "should fail in html" do
        get :unshare, {:id => @paper.id, :user_id => @user2.id}
        expect(response.status).to eq 406
      end

      it "should not fail in js" do
        xhr :get, :unshare, {:id => @paper.id, :user_id => @user2.id}
        expect(response.status).to eq 200
        expect(response).to render_template "update_shared_user_block"
      end
    end

    it "should support destroy" do
      delete :destroy, {:id => @paper.id}
      expect(response.status).to eq 302
      expect(response).to redirect_to my_video_papers_path()
    end

    it "should support share" do
      get :share, {:id => @paper.id}
      expect(response.status).to eq 200
    end

    it "should support shared" do
      user2 = FactoryGirl.create(:user)
      user3 = FactoryGirl.create(:user)
      shared_paper = FactoryGirl.create(:shared_paper, :user => user2, :video_paper => @paper);
      xhr :get, :shared, {:id => @paper.id, :shared_paper => {:user_id => user3.id}}
      expect(response.status).to eq 200
      expect(response).to render_template "update_shared_user_block"
    end

    it "should support edit_section_duration with a valid section" do
      section = FactoryGirl.create(:section, :title => "Section1", :video_paper => @paper)
      get :edit_section_duration, {:id => @paper.id, :section => section.title}
      expect(response.status).to eq 200
    end

    it "should support edit_section_duration without a valid section" do
      get :edit_section_duration, {:id => @paper.id, :section => "invalid"}
      expect(response.status).to eq 200
    end

    it "should support update_section_duration with a valid section and valid attributes" do
      section = FactoryGirl.create(:section, :title => "Section1", :video_paper => @paper)
      get :update_section_duration, {:id => @paper.id, :section => {:id => section.id, :video_start_time => 1, :video_stop_time => 10}}
      expect(response.status).to eq 302
      expect(response).to redirect_to "#{video_paper_path(@paper)}#section1"
    end

    it "should support update_section_duration with a valid section and invalid attributes" do
      section = FactoryGirl.create(:section, :title => "Section1", :video_paper => @paper)
      get :update_section_duration, {:id => @paper.id, :section => {:id => section.id, :video_start_time => "foo", :video_stop_time => "bar"}}
      expect(response.status).to eq 302
      expect(response).to redirect_to "#{video_paper_path(@paper)}#section1"
    end
  end
end