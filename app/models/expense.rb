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

    # Convert to cents (integers) to avoid floating point issues
    total_cents = (amount * 100).to_i
    base_amount_cents = total_cents / users.count
    extra_pennies = total_cents % users.count

    users.shuffle.each do |user|
      amount_owed_cents = base_amount_cents
      got_extra_penny = false

      if extra_pennies > 0
        amount_owed_cents += 1
        extra_pennies -= 1
        got_extra_penny = true
      end

      # Convert back to dollars for storage
      amount_owed = amount_owed_cents / 100.0

      share = expense_shares.create!(user: user, amount_owed: amount_owed.round(2))

      next unless got_extra_penny

      CharityDonation.create!(
        expense_share: share,
        amount_cents: 1,
        charity_name: 'Clean Water Fund'
      )
    end
  end

  def total_shared_amount
    expense_shares.sum(:amount_owed)
  end

  def remaining_to_split
    amount - total_shared_amount
  end
end
