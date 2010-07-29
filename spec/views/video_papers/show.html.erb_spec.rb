require 'spec_helper'

describe "/video_papers/show.html.erb" do
  include VideoPapersHelper
  before(:each) do
    assigns[:video_paper] = @video_paper = stub_model(VideoPaper,
      :title => "value for title"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
  end
end
