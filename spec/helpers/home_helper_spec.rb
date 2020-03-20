require 'spec_helper'

describe HomeHelper do

  it "embed_help_video() should use the environment variable if available" do
    ENV["HELP_VIDEO_FOLDER_URL"] = "foo-bar-baz"
    embed = helper.embed_help_video("bing")
    ENV.delete("HELP_VIDEO_FOLDER_URL")
    expect(embed).to include "foo-bar-baz"
    expect(embed).to include "bing"
  end

  it "embed_help_video() fallback if the environment variable is not available" do
    embed = helper.embed_help_video("bong")
    expect(embed).not_to include "foo-bar-baz"
    expect(embed).to include "models-resources.concord.org"
    expect(embed).to include "bong"
  end

end
