class Expense < ApplicationRecord
  belongs_to :paid_by, class_name: 'User'

  validates :description, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :paid_by, presence: true
end
