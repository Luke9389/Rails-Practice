FactoryBot.define do
  factory :expense do
    description { "Lunch at restaurant" }
    amount { 25.50 }
    date { Date.today }
    association :paid_by, factory: :user
  end
end