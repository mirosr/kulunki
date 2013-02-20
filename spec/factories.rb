FactoryGirl.define do
  sequence :secure_password do
    Forgery(:basic).password(allow_special: true)
  end

  sequence :sorcery_random_token do
    Sorcery::Model::TemporaryToken.generate_random_token
  end

  factory :user do
    username { Forgery(:basic).text(allow_upper: false) }
    email { Forgery(:email).address }
    password { generate(:secure_password) }
    password_confirmation { |u| u.password }
    full_name { Forgery(:name).full_name }

    trait :admin do
      role 'admin'
    end

    factory :user_with_reset_password_token do
      reset_password_token { generate(:sorcery_random_token) }
      reset_password_token_expires_at { 1.week.from_now }
      reset_password_email_sent_at { 2.hours.ago }
    end

    factory :user_with_expired_reset_password_token do
      reset_password_token { generate(:sorcery_random_token) }
      reset_password_token_expires_at { 1.week.ago }
      reset_password_email_sent_at { 2.weeks.ago }
    end
  end

  factory :household do
    name { Forgery(:basic).text }
  end
end
