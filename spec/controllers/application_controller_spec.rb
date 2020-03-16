require "spec_helper"

describe ApplicationController do

  # expose protected methods in controller for testing and override
  # authenticate_admin! devise method
  controller do
    def authenticate_admin!
      # devise method called by ApplicationController#authenticate_resource!
      true
    end
    def authenticate_resource!
      super
    end
    def dom_friend(args)
      super(args)
    end
  end

  it "should support authenticate_resource!" do
    expect(controller.authenticate_resource!).to eq true
  end

  it "should supprt dom_friend" do
    expect(controller.dom_friend({id: "foo"})).to eq "foo"
    expect(controller.dom_friend({id: "foo bar"})).to eq "foo_bar"
    expect(controller.dom_friend({id: "foo bar baz"})).to eq "foo_bar_baz"
  end
end