require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      expense = build(:expense)
      expect(expense).to be_valid
    end

    it 'is not valid without a description' do
      expense = build(:expense, description: nil)
      expect(expense).not_to be_valid
      expect(expense.errors[:description]).to include("can't be blank")
    end

    it 'is not valid without an amount' do
      expense = build(:expense, amount: nil)
      expect(expense).not_to be_valid
    end

    it 'is not valid with a negative amount' do
      expense = build(:expense, amount: -5)
      expect(expense).not_to be_valid
      expect(expense.errors[:amount]).to include('must be greater than 0')
    end

    it 'is not valid without a date' do
      expense = build(:expense, date: nil)
      expect(expense).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a user who paid' do
      user = create(:user)
      expense = create(:expense, paid_by: user)
      expect(expense.paid_by).to eq(user)
    end
  end
end
