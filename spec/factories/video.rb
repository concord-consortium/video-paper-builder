FactoryBot.define do
  factory :video do
    upload_uri { '/help-videos/getting-started.mp4' }
    association :video_paper
    private { false }
  end

  factory :video_with_thumbnail, :parent => :video do
    association :video_paper
    thumbnail { File.new("#{Rails.root}/spec/factories/images/thumbnail.jpeg") }
    private { false }
  end

  factory :transcoded_video, :parent => :video do
    transcoded_uri { "/help-videos/getting-started.mp4" }
    aws_transcoder_state { "completed" }
    processed { true }
    duration { "268" }
    description { "this is an awesome description" }
  end

end
