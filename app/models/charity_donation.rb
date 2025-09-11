class CharityDonation < ApplicationRecord
  belongs_to :expense_share
  delegate :user, to: :expense_share

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :charity_name, presence: true
  validates :expense_share, presence: true, uniqueness: true
end
