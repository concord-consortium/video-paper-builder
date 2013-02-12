FactoryGirl.define do
  factory :shared_paper do
    association :user
    association :video_paper
  end
end
