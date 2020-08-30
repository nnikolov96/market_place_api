FactoryBot.define do

  factory :product do
    title { "Niki product" }
    price { "9.99" }
    published { false }
    association :user

    trait :published do
      published { true }
    end
  end


end
