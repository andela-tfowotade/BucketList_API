FactoryGirl.define do
  factory :item do
    name { Faker::Lorem.sentence }
    target_completion_date { 60.days.from_now.to_date }
  end
end
