class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :paid_expenses, class_name: 'Expense', foreign_key: 'paid_by_id'

  has_many :expense_shares, dependent: :destroy
  has_many :shared_expenses, through: :expense_shares, source: :expense
end
