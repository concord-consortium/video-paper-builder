Factory.sequence :user_email do |e|
  "person_#{e}@velir.com"
end

Factory.define :user do |u|
  u.email {Factory.next(:user_email)}
  u.password "funstuff"
  u.password_confirmation "funstuff"
end

Factory.define :admin do |a|
  a.email {Factory.next(:user_email)}
  a.password "funstuff"
  a.password_confirmation "funstuff"
end