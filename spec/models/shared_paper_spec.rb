require 'spec_helper'

describe SharedPaper do
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

  it "should be destroyed when the user is destroyed" do
    paper = FactoryGirl.create(:shared_paper)
    paper_id = paper.id
    paper.user.destroy
    SharedPaper.find_by_id(paper_id).should be_nil
  end

end
