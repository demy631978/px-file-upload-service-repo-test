FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    encrypted_password { 'Asdf123' }
  end
end