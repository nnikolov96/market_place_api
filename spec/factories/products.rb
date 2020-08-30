FactoryBot.define do

  factory :product do
    title { "Niki product" }
    price { "9.99" }
    published { false }
    association :user
    quantity { 0 }

    trait :published do
      published { true }
    end
    trait :with_quantity do
      quantity { 5 }
    end
  end


end
