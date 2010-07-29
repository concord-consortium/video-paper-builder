require 'spec_helper'

describe VideoPapersController do

  def mock_video_paper(stubs={})
    @mock_video_paper ||= mock_model(VideoPaper, stubs)
  end

  describe "GET index" do
    it "assigns all video_papers as @video_papers" do
      VideoPaper.stub(:find).with(:all).and_return([mock_video_paper])
      get :index
      assigns[:video_papers].should == [mock_video_paper]
    end
  end

  describe "GET show" do
    it "assigns the requested video_paper as @video_paper" do
      VideoPaper.stub(:find).with("37").and_return(mock_video_paper)
      get :show, :id => "37"
      assigns[:video_paper].should equal(mock_video_paper)
    end
  end

  describe "GET new" do
    it "assigns a new video_paper as @video_paper" do
      VideoPaper.stub(:new).and_return(mock_video_paper)
      get :new
      assigns[:video_paper].should equal(mock_video_paper)
    end
  end

  describe "GET edit" do
    it "assigns the requested video_paper as @video_paper" do
      VideoPaper.stub(:find).with("37").and_return(mock_video_paper)
      get :edit, :id => "37"
      assigns[:video_paper].should equal(mock_video_paper)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created video_paper as @video_paper" do
        VideoPaper.stub(:new).with({'these' => 'params'}).and_return(mock_video_paper(:save => true))
        post :create, :video_paper => {:these => 'params'}
        assigns[:video_paper].should equal(mock_video_paper)
      end

      it "redirects to the created video_paper" do
        VideoPaper.stub(:new).and_return(mock_video_paper(:save => true))
        post :create, :video_paper => {}
        response.should redirect_to(video_paper_url(mock_video_paper))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved video_paper as @video_paper" do
        VideoPaper.stub(:new).with({'these' => 'params'}).and_return(mock_video_paper(:save => false))
        post :create, :video_paper => {:these => 'params'}
        assigns[:video_paper].should equal(mock_video_paper)
      end

      it "re-renders the 'new' template" do
        VideoPaper.stub(:new).and_return(mock_video_paper(:save => false))
        post :create, :video_paper => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested video_paper" do
        VideoPaper.should_receive(:find).with("37").and_return(mock_video_paper)
        mock_video_paper.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :video_paper => {:these => 'params'}
      end

      it "assigns the requested video_paper as @video_paper" do
        VideoPaper.stub(:find).and_return(mock_video_paper(:update_attributes => true))
        put :update, :id => "1"
        assigns[:video_paper].should equal(mock_video_paper)
      end

      it "redirects to the video_paper" do
        VideoPaper.stub(:find).and_return(mock_video_paper(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(video_paper_url(mock_video_paper))
      end
    end

    describe "with invalid params" do
      it "updates the requested video_paper" do
        VideoPaper.should_receive(:find).with("37").and_return(mock_video_paper)
        mock_video_paper.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :video_paper => {:these => 'params'}
      end

      it "assigns the video_paper as @video_paper" do
        VideoPaper.stub(:find).and_return(mock_video_paper(:update_attributes => false))
        put :update, :id => "1"
        assigns[:video_paper].should equal(mock_video_paper)
      end

      it "re-renders the 'edit' template" do
        VideoPaper.stub(:find).and_return(mock_video_paper(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested video_paper" do
      VideoPaper.should_receive(:find).with("37").and_return(mock_video_paper)
      mock_video_paper.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the video_papers list" do
      VideoPaper.stub(:find).and_return(mock_video_paper(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(video_papers_url)
    end
  end

end
