class Expense < ApplicationRecord
  belongs_to :paid_by, class_name: 'User'

  validates :description, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :paid_by, presence: true

  has_many :expense_shares, dependent: :destroy
  has_many :shared_with_users, through: :expense_shares, source: :user

  def split_equally_among(users)
    return if users.empty?

    amount_per_person = amount / users.count

    users.each do |user|
      expense_shares.create!(user: user, amount_owed: amount_per_person)
    end
  end

  def total_shared_amount
    expense_shares.sum(:amount_owed)
  end

  def remaining_to_split
    amount - total_shared_amount
  end
end
