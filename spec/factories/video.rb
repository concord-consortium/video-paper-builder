FactoryGirl.define do
  factory :video do
    entry_id 'fake_entry_id'
    association :video_paper
    private false
  end

  factory :real_video, :parent => :video do
    entry_id 1 # TODO: update for AWS
    association :video_paper
    description "this is an awesome description"
    private false
  end

end
