FactoryBot.define do
  factory :section do
  	title { 'section title' }
  	association :video_paper
  end
end