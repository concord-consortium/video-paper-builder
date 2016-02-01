FactoryGirl.define do
  factory :video do
    upload_uri 'uploads/test.mov'
    association :video_paper
    private false
  end

  factory :real_video, :parent => :video do
    association :video_paper
    description "this is an awesome description"
    private false
  end

end
