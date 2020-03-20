require 'spec_helper'

describe VideoPapersController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/video_papers" }.should route_to(:controller => "video_papers", :action => "index")
    end

    it "recognizes and generates #index?user=<id>" do
      user = FactoryGirl.create(:user)
      paper = FactoryGirl.create(:video_paper, :title => "test", :user => user, :status => "unpublished")
      { :get => "/video_papers?user=#{user.id}" }.should route_to(:controller => "video_papers", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/video_papers/new" }.should route_to(:controller => "video_papers", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/video_papers/1" }.should route_to(:controller => "video_papers", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/video_papers/1/edit" }.should route_to(:controller => "video_papers", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/video_papers" }.should route_to(:controller => "video_papers", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/video_papers/1" }.should route_to(:controller => "video_papers", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/video_papers/1" }.should route_to(:controller => "video_papers", :action => "destroy", :id => "1")
    end
  end
end
