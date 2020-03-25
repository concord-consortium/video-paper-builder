require 'spec_helper'

describe VideoPapersController do
  describe "routing" do
    it "recognizes and generates #index" do
      expect({ :get => "/video_papers" }).to route_to(:controller => "video_papers", :action => "index")
    end

    it "recognizes and generates #index?user=<id>" do
      user = FactoryGirl.create(:user)
      paper = FactoryGirl.create(:video_paper, :title => "test", :user => user, :status => "unpublished")
      expect({ :get => "/video_papers?user=#{user.id}" }).to route_to(:controller => "video_papers", :action => "index")
    end

    it "recognizes and generates #new" do
      expect({ :get => "/video_papers/new" }).to route_to(:controller => "video_papers", :action => "new")
    end

    it "recognizes and generates #show" do
      expect({ :get => "/video_papers/1" }).to route_to(:controller => "video_papers", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      expect({ :get => "/video_papers/1/edit" }).to route_to(:controller => "video_papers", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      expect({ :post => "/video_papers" }).to route_to(:controller => "video_papers", :action => "create")
    end

    it "recognizes and generates #update" do
      expect({ :put => "/video_papers/1" }).to route_to(:controller => "video_papers", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      expect({ :delete => "/video_papers/1" }).to route_to(:controller => "video_papers", :action => "destroy", :id => "1")
    end
  end
end
