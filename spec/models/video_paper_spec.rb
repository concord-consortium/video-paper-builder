require 'spec_helper'

describe VideoPaper do
  before(:each) do
    @user = FactoryBot.create(:user, :email=>"spec_test@velir.com")
    @second_user = FactoryBot.create(:user,:email=>"super_spec_test@velir.com")
    @valid_attributes = {
      :title => "value for title",
      :owner_id => @user.id
    }
  end

  it "should have a title" do
    video_paper = VideoPaper.new
    video_paper.user = @user
    expect(video_paper.save).to be_falsey
  end

  it "should require an owner_id" do
    video_paper = VideoPaper.new(:title=>"This is a valid title")
    expect(video_paper.save).to be_falsey
  end

  it "should have preset sections" do
    video_paper = FactoryBot.create(:video_paper)
    Settings.sections.each do |section_setting|
      section = video_paper.sections.find_by_title(section_setting[1]["title"])
      expect(section).not_to be nil
    end
    expect(video_paper.sections.count).to equal Settings.sections.count
  end

  it "should let you share the paper to another user" do
    video_paper = FactoryBot.create(:video_paper)

    share_attributes = {
      :user_id => @second_user.id,
      :notes=> "I love lamp"
    }
    expect(video_paper.share(share_attributes)).to be_truthy
    paper = video_paper.shared_papers.find_by_user_id(share_attributes[:user_id])
    expect(video_paper.shared_papers.include?(paper)).to be_truthy
  end

  it "shouldn't let you share the paper to the same user twice.  duplicates make kittens sad" do
    video_paper = FactoryBot.create(:video_paper)

    share_attributes = {
      :user_id => @second_user.id,
      :notes => "waffles are great."
    }
    expect(video_paper.share(share_attributes)).to be_truthy
    paper = video_paper.shared_papers.find_by_user_id(share_attributes[:user_id])
    expect(video_paper.shared_papers.include?(paper)).to be_truthy

    share_attributes[:notes] = "well waffles aren't fantastic."
    expect(video_paper.share(share_attributes)).to be_falsey

    second_paper = video_paper.shared_papers.find_by_notes(share_attributes[:notes])
    expect(video_paper.shared_papers.include?(second_paper)).to be_falsey
  end

  it "should let you unshare the paper when need be." do
    video_paper = FactoryBot.create(:video_paper)

    share_attributes = {
      :user_id => @second_user.id,
      :notes=> "I love lamp"
    }
    expect(video_paper.share(share_attributes)).to be_truthy
    paper = video_paper.shared_papers.find_by_user_id(share_attributes[:user_id])

    expect(video_paper.shared_papers.include?(paper)).to be_truthy

    expect(video_paper.unshare(share_attributes[:user_id])).to be_truthy

    expect(video_paper.shared_papers.include?(paper)).to be_falsey
  end

  it "should indicate a share was unsuccesful when you give it poor attributes" do
    video_paper = FactoryBot.create(:video_paper)

    share_attributes = {
      :user_id => 'I am not right at all',
      :notes => 'ditto.'
    }

    expect(video_paper.share(share_attributes)).to be_falsey
    paper = video_paper.shared_papers.find_by_user_id(share_attributes[:user_id])
    #video_paper.shared_papers.include?(paper).should be_false
  end

  it "should produce a human readable created by date" do
    video_paper = FactoryBot.create(:video_paper)

    pretty_date = Time.now.utc
    pretty_date = pretty_date.strftime("%A %B #{pretty_date.day.ordinalize}, %Y")

    expect(video_paper.format_created_date).to eq(pretty_date)

  end

  it "should default to unpublished when a new video paper is created" do
    video_paper = FactoryBot.create(:video_paper)

    expect(video_paper.published?).to be_falsey
    expect(video_paper.unpublished?).to be_truthy
    expect(video_paper.status).to eq('unpublished')
  end

  it "should display as published when published! is called" do
    video_paper = FactoryBot.create(:video_paper)

    video_paper.publish!
    expect(video_paper.published?).to be_truthy
    expect(video_paper.unpublished?).to be_falsey
    expect(video_paper.status).to eq('published')
  end

  it "should display as unpublished when unpublish! is called" do
    video_paper = FactoryBot.create(:video_paper)

    video_paper.publish!
    video_paper.unpublish!
    expect(video_paper.published?).to be_falsey
    expect(video_paper.unpublished?).to be_truthy
    expect(video_paper.status).to eq('unpublished')
  end

  it "should handle order_by" do
    expect(subject.class.order_by("title_desc")).to eq "title DESC"
    expect(subject.class.order_by("title_asc")).to eq "title ASC"
    expect(subject.class.order_by("date_desc")).to eq "created_at DESC"
    expect(subject.class.order_by("date_asc")).to eq "created_at ASC"
    expect(subject.class.order_by("anything else")).to eq "created_at DESC"
  end

  describe "video_status" do
    it "should handle no video" do
      video_paper = FactoryBot.create(:video_paper)
      expect(video_paper.video_status).to eq "No video uploaded"
    end

    it "should handle private videos" do
      video_paper = FactoryBot.create(:video_paper)
      video_paper.video = FactoryBot.build(:video, :private => true)
      expect(video_paper.video_status).to eq "Private"
    end

    it "should handle public videos" do
      video_paper = FactoryBot.create(:video_paper)
      video_paper.video = FactoryBot.build(:video, :private => false)
      expect(video_paper.video_status).to eq "Public"
    end
  end

end
