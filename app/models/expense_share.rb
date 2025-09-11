class ExpenseShare < ApplicationRecord
  belongs_to :expense
  belongs_to :user

  validates :amount_owed, presence: true, numericality: { greater_than: 0 }
  validates :user_id, uniqueness: { scope: :expense_id,
                                    message: "can only have one share per expense" }

  has_one :charity_donation, dependent: :destroy
end
