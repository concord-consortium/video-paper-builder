require 'spec_helper'

describe "/video_papers/edit.html.erb" do
  include VideoPapersHelper

  before(:each) do
    assigns[:video_paper] = @video_paper = stub_model(VideoPaper,
      :new_record? => false,
      :title => "value for title"
    )
  end

  it "renders the edit video_paper form" do
    render

    response.should have_tag("form[action=#{video_paper_path(@video_paper)}][method=post]") do
      with_tag('input#video_paper_title[name=?]', "video_paper[title]")
    end
  end
end
