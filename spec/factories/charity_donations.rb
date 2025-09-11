FactoryBot.define do
  factory :charity_donation do
    user { nil }
    amount_cents { 1 }
    charity_name { "MyString" }
    expense_share { nil }
  end
end
