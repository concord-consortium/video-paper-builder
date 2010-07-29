require 'spec_helper'

describe "/video_papers/new.html.erb" do
  include VideoPapersHelper

  before(:each) do
    assigns[:video_paper] = stub_model(VideoPaper,
      :new_record? => true,
      :title => "value for title"
    )
  end

  it "renders new video_paper form" do
    render

    response.should have_tag("form[action=?][method=post]", video_papers_path) do
      with_tag("input#video_paper_title[name=?]", "video_paper[title]")
    end
  end
end
