class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :paid_expenses, class_name: 'Expense', foreign_key: 'paid_by_id'

  has_many :expense_shares, dependent: :destroy
  has_many :shared_expenses, through: :expense_shares, source: :expense

  def total_paid
    paid_expenses.sum(:amount)
  end

  def total_owed
    expense_shares.sum(:amount_owed)
  end

  def net_balance
    total_paid - total_owed
  end

  def balance_with(other_user)
    paid_for_other = paid_expenses.joins(:expense_shares)
                                  .where(expense_shares: { user: other_user })
                                  .sum('expense_shares.amount_owed')

    owed_to_other = expense_shares.joins(:expense)
                                  .where(expenses: { paid_by: other_user })
                                  .sum(:amount_owed)

    paid_for_other - owed_to_other
  end
end
