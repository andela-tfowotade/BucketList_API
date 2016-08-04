FactoryGirl.define do
  factory :item do
    name { Faker::Lorem.sentence }
  end
end
