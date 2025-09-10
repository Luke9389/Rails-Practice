FactoryBot.define do
  factory :expense_share do
    association :expense
    association :user
    amount_owed { 10.00 }
  end
end
