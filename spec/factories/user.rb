Factory.define :user do |u|
  u.email "video_bob@velir.com"
  u.password "funstuff"
  u.password_confirmation "funstuff"
end

Factory.define :admin do |a|
  a.email "video_ted@velir.com"
  a.password "funstuff"
  a.password_confirmation "funstuff"
end