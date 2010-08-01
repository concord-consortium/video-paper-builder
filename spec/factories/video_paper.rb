Factory.sequence :vp_title do |t|
  "Test Title: #{t}"
end

Factory.define :video_paper do |vp|
  vp.title {Factory.next(:vp_title)}
  vp.association :user, :factory=>:user
end