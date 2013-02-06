FactoryGirl.define do
  factory :user do
    username { Forgery(:basic).text(allow_upper: false) }
    email { Forgery(:email).address }
    password { Forgery(:basic).password(allow_special: true) }
    password_confirmation { |u| u.password }
  end
end
