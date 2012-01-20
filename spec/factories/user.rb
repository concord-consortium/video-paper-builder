Factory.sequence :user_email do |e|
  "person_#{e}@velir.com"
end

Factory.define :user do |u|
  u.first_name  "Robert"
  u.last_name  "Bobberson"
  u.email {Factory.next(:user_email)}
  u.password "funstuff"
  u.password_confirmation "funstuff"
  u.after_create { |u| u.confirm! }
end

Factory.define :invited_user, :class => 'user' do |u|
  u.first_name  "Robert"
  u.last_name  "Bobberson"
  u.email {Factory.next(:user_email)}
  u.password "funstuff"
  u.password_confirmation "funstuff"
  u.after_build { |u|
    u.resend_invitation! }
end

Factory.define :admin do |a|
  a.first_name  "Jim"
  a.last_name  "Smith"
  a.email {Factory.next(:user_email)}
  a.password "funstuff"
  a.password_confirmation "funstuff"
  a.after_create { |u| u.confirm! }
end