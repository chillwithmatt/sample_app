FactoryGirl.define do
  factory :user do
    name     "Powerful Matt"
    email    "mail@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end