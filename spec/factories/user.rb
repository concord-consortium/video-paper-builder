Factory.sequence :user_email do |e|
  "person_#{e}@velir.com"
end

Factory.define :user do |u|
  u.first_name  "Bob"
  u.last_name  "Smith"
  u.email {Factory.next(:user_email)}
  u.password "funstuff"
  u.password_confirmation "funstuff"
end

Factory.define :admin do |a|
  a.first_name  "Jim"
  a.last_name  "Smith"
  a.email {Factory.next(:user_email)}
  a.password "funstuff"
  a.password_confirmation "funstuff"
end