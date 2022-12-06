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
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
  factory :invoice do
    customer
    merchant
    status {"In Progress"}
  end
  factory :invoice_item do
    invoice
    item
    quantity {Faker::Number.between(from: 1, to: 100)}
    unit_price {Faker::Number.between(from: 1, to: 1_000)}
  end
  factory :transaction do
    credit_card_number {Faker::Number.number(digits: 16)}
    credit_card_expiration_date {Faker::Number.decimal_part(digits: 4)}
    result {"Successful"}
    invoice
  end
end
