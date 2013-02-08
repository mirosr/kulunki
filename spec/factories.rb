FactoryGirl.define do
  sequence :secure_password do
    Forgery(:basic).password(allow_special: true)
  end

  factory :user do
    username { Forgery(:basic).text(allow_upper: false) }
    email { Forgery(:email).address }
    password { generate(:secure_password) }
    password_confirmation { |u| u.password }
  end
end
