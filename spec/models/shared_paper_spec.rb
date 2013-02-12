require 'spec_helper'

describe SharedPaper do
  before(:each) do
    @valid_attributes = {
      :video_paper_id => FactoryGirl.create(:video_paper).id,
      :user_id => FactoryGirl.create(:user).id,
      :notes=>"I like beets."
    }
  end

  it "shouldn't require a note" do
    paper = FactoryGirl.create(:shared_paper)

    paper.save.should be_true
  end

  it "should require a paper ID" do
    paper = FactoryGirl.build(:shared_paper, :video_paper => nil)

    paper.save.should be_false
  end

  it "should require a user ID" do
    paper = FactoryGirl.build(:shared_paper, :user => nil)

    paper.save.should be_false
  end

  it "shouldn't save two saves of the same exact paper/user combo" do
    paper = FactoryGirl.build(:shared_paper)
    paper.save.should be_true
    paper_2 = FactoryGirl.build(:shared_paper, :user => paper.user, :video_paper => paper.video_paper)
    paper_2.save.should be_false
  end

  it "shouldn't save a share of a user_id that doesn't exist" do
    paper = FactoryGirl.build(:shared_paper, :user => nil, :user_id => 'waffles are fantastical')
    paper.save.should be_false
  end
end
