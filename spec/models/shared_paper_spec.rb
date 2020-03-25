require 'spec_helper'

describe SharedPaper do
  it "shouldn't require a note" do
    paper = FactoryBot.create(:shared_paper)

    expect(paper.save).to be_truthy
  end

  it "should require a paper ID" do
    paper = FactoryBot.build(:shared_paper, :video_paper => nil)

    expect(paper.save).to be_falsey
  end

  it "should require a user ID" do
    paper = FactoryBot.build(:shared_paper, :user => nil)

    expect(paper.save).to be_falsey
  end

  it "shouldn't save two saves of the same exact paper/user combo" do
    paper = FactoryBot.build(:shared_paper)
    expect(paper.save).to be_truthy
    paper_2 = FactoryBot.build(:shared_paper, :user => paper.user, :video_paper => paper.video_paper)
    expect(paper_2.save).to be_falsey
  end

  it "shouldn't save a share of a user_id that doesn't exist" do
    paper = FactoryBot.build(:shared_paper, :user => nil, :user_id => 'waffles are fantastical')
    expect(paper.save).to be_falsey
  end

  it "should be destroyed when the user is destroyed" do
    paper = FactoryBot.create(:shared_paper)
    paper_id = paper.id
    paper.user.destroy
    expect(SharedPaper.find_by_id(paper_id)).to be_nil
  end

end
