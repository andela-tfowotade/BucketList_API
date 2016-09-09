FactoryGirl.define do
  factory :bucket_list do
    name { Faker::Lorem.sentence }
    user
  end
end
