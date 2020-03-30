require 'spec_helper'

describe VideoPapersHelper do
  before(:each) do
    @user = FactoryBot.create(:user, :email => "foo@bar.com")
    @paper = FactoryBot.create(:video_paper, :title => "Video1", :status => "unpublished", :user => @user);
  end

  describe "get_video_paper_thumbnail" do
    it "should work with no video" do
      expect(helper.get_video_paper_thumbnail(@paper)).to eq "<div class=\"no-video\"></div>"
    end

    it "should work with video with no thumbnail" do
      @paper.video = FactoryBot.create(:video, :video_paper => @paper)
      expect(helper.get_video_paper_thumbnail(@paper)).to eq "<div class=\"no-thumbnail\"></div>"
    end

    it "should work with video with a thumbnail" do
      @paper.video = FactoryBot.create(:video_with_thumbnail, :video_paper => @paper)
      expect(helper.get_video_paper_thumbnail(@paper)).to include " alt=\"Thumbnail\""
    end

    it "should work with video that has been transcoded" do
      @paper.video = FactoryBot.create(:video, :video_paper => @paper, :transcoded_uri => "TRANSCODED_URI", :aws_transcoder_state => "completed")
      expect(helper.get_video_paper_thumbnail(@paper)).to include "TRANSCODED_URI"
    end
  end

  describe "get_video_paper_thumbnail_with_default" do
    before(:each) do
      @default_img_url = "http://example.com/default.png"
    end

    it "should work with no video" do
      expect(helper.get_video_paper_thumbnail_with_default(@paper, @default_img_url)).to eq image_tag(@default_img_url)
    end

    it "should work with video with no thumbnail" do
      @paper.video = FactoryBot.create(:video, :video_paper => @paper)
      expect(helper.get_video_paper_thumbnail_with_default(@paper, @default_img_url)).to eq image_tag(@default_img_url)
    end

    it "should work with video with a thumbnail" do
      @paper.video = FactoryBot.create(:video_with_thumbnail, :video_paper => @paper)
      expect(helper.get_video_paper_thumbnail_with_default(@paper, @default_img_url)).to include " alt=\"Thumbnail\""
    end

    it "should work with video that has been transcoded" do
      @paper.video = FactoryBot.create(:video, :video_paper => @paper, :transcoded_uri => "TRANSCODED_URI", :aws_transcoder_state => "completed")
      expect(helper.get_video_paper_thumbnail_with_default(@paper, @default_img_url)).to include "TRANSCODED_URI"
    end
  end

  describe "edit_section_link" do
    it "should return a link" do
      link = helper.edit_section_link({:video_paper => @paper, :section => "foo", :text => "bar"})
      expect(link).to eq "<a href=\"#{@paper.id}/edit_section?section=foo\" title=\"Edit foo Section\">bar foo</a>"
    end
  end

  describe "is_last?" do
    it "should return nil if count % 4 != 0" do
      expect(helper.is_last?(1)).to eq nil
    end

    it "should return 'last' if count % 4 == 0" do
      expect(helper.is_last?(4)).to eq "last"
    end
  end

  describe "pick_arrow" do
    it "works for top and matching order_by" do
      controller.params[:order_by] = "foo"
      arrow = helper.pick_arrow("foo", {:position => "top"})
      expect(arrow).to include "top_arrow_active"
    end

    it "works for top and non-matching order_by" do
      controller.params[:order_by] = "bar"
      arrow = helper.pick_arrow("foo", {:position => "top"})
      expect(arrow).to include "top_arrow_normal"
    end

    it "works for bottom and matching order_by" do
      controller.params[:order_by] = "foo"
      arrow = helper.pick_arrow("foo", {:position => "bottom"})
      expect(arrow).to include "bottom_arrow_active"
    end

    it "works for bottom with no order_by with date_desc" do
      arrow = helper.pick_arrow("date_desc", {:position => "bottom"})
      expect(arrow).to include "bottom_arrow_active"
    end

    it "works for bottom and non-matching order_by" do
      controller.params[:order_by] = "bar"
      arrow = helper.pick_arrow("foo", {:position => "bottom"})
      expect(arrow).to include "bottom_arrow_normal"
    end
  end

end
