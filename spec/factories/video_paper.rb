FactoryGirl.define do
  sequence :vp_title do |t|
    "Test Title: #{t}"
  end

  # status == "published" | "unpublished"
  factory :video_paper do
    title {generate(:vp_title)}
    association :user
  end

  factory :video do
    entry_id { KalturaUtil.find_test_video_id }
    association :video_paper
    description "this is an awesome description"
    private false
  end
end
