class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :paid_expenses, class_name: 'Expense', foreign_key: 'paid_by_id'
end
