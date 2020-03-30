FactoryBot.define do
  sequence :user_email do |e|
    "person_#{e}@velir.com"
  end

  factory :user do
    first_name  { "Robert" }
    last_name   { "Bobberson" }
    email {generate(:user_email)}
    password { "funstuff" }
    password_confirmation { "funstuff" }
    after(:create) { |u| u.confirm }
  end

  factory :invited_user, :parent => :user do
    after(:build) { |u| u.invite! }
  end

  factory :admin do
    first_name  { "Jim" }
    last_name  { "Smith" }
    email {generate(:user_email)}
    password { "funstuff" }
    password_confirmation { "funstuff" }
    after(:create) { |u| u.confirm }
  end

end
