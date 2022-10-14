FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    phone_number  { Faker::PhoneNumber.cell_phone }
    password { Faker::Internet.password }
    key { SecureRandom.hex }
  end
end
