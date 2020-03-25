FactoryBot.define do
  sequence :vp_title do |t|
    "Test Title: #{t}"
  end

  # status == "published" | "unpublished"
  factory :video_paper do
    title {generate(:vp_title)}
    association :user
  end
end
