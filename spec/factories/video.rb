FactoryGirl.define do
  factory :video do
    upload_uri 'uploads/test.mov'
    association :video_paper
    private false
  end

  factory :video_with_thumbnail, :parent => :video do
    association :video_paper
    thumbnail File.new("#{Rails.root}/spec/factories/images/thumbnail.jpeg")
    private false
  end

  factory :real_video, :parent => :video do
    association :video_paper
    description "this is an awesome description"
    private false
  end

end
