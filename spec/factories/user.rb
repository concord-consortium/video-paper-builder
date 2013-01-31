FactoryGirl.define do
  sequence :user_email do |e|
    "person_#{e}@velir.com"
  end

  factory :user do
    first_name  "Robert"
    last_name  "Bobberson"
    email {Factory.next(:user_email)}
    password "funstuff"
    password_confirmation "funstuff"
    after(:create) { |u| u.confirm! }
  end

  factory :invited_user, :class => 'user' do
    first_name  "Robert"
    last_name  "Bobberson"
    email {Factory.next(:user_email)}
    password "funstuff"
    password_confirmation "funstuff"
    after(:build) { |u| u.invite! }
  end

  factory :admin do
    first_name  "Jim"
    last_name  "Smith"
    email {Factory.next(:user_email)}
    password "funstuff"
    password_confirmation "funstuff"
    after(:create) { |u| u.confirm! }
  end
end