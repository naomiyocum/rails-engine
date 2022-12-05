FactoryBot.define do
  factory :merchant do
    name { Faker::JapaneseMedia::OnePiece.character }
  end
  factory :item do
    name { Faker::JapaneseMedia::StudioGhibli.movie }
    description { Faker::JapaneseMedia::StudioGhibli.quote }
    unit_price { Faker::Number.between(from: 1, to: 1_000) }
    merchant
  end
end
