require 'spec_helper'

describe "/video_papers/index.html.erb" do
  include VideoPapersHelper

  before(:each) do
    assigns[:video_papers] = [
      stub_model(VideoPaper,
        :title => "value for title"
      ),
      stub_model(VideoPaper,
        :title => "value for title"
      )
    ]
  end

  it "renders a list of video_papers" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
  end
end
