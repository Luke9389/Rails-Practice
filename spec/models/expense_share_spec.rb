require 'rails_helper'

RSpec.describe ExpenseShare, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      expense_share = build(:expense_share)
      expect(expense_share).to be_valid
    end

    it 'is not valid without an amount_owed' do
      expense_share = build(:expense_share, amount_owed: nil)
      expect(expense_share).not_to be_valid
    end

    it 'is not valid with a negative amount_owed' do
      expense_share = build(:expense_share, amount_owed: -5)
      expect(expense_share).not_to be_valid
    end

    it 'is not valid with zero amount_owed' do
      expense_share = build(:expense_share, amount_owed: 0)
      expect(expense_share).not_to be_valid
    end

    it 'prevents duplicate user shares for same expense' do
      expense = create(:expense)
      user = create(:user)
      create(:expense_share, expense: expense, user: user)

      duplicate_share = build(:expense_share, expense: expense, user: user)
      expect(duplicate_share).not_to be_valid
      expect(duplicate_share.errors[:user_id]).to include('can only have one share per expense')
    end
  end

  describe 'associations' do
    it 'belongs to an expense' do
      expense_share = create(:expense_share)
      expect(expense_share.expense).to be_present
    end

    it 'belongs to a user' do
      expense_share = create(:expense_share)
      expect(expense_share.user).to be_present
    end
  end
end
