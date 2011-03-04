Factory.sequence :vp_title do |t|
  "Test Title: #{t}"
end

# status == "published" | "unpublished"
Factory.define :video_paper do |vp|
  vp.title {Factory.next(:vp_title)}
  vp.association :user
end

Factory.define :video do |v|
  v.entry_id { KalturaUtil.find_test_video_id }
  v.association :video_paper
  v.description "this is an awesome description"
  v.private false
  v.language {Language.find_by_code('en')}
end
