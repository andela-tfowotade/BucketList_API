FactoryGirl.define do
  factory :bucket_list do
    name { Faker::Lorem.sentence }
    created_by { Faker::Name.first_name }
    user
  end
end
