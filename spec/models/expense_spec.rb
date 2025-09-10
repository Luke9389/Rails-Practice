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

  describe 'expense splitting' do
    let(:expense) { create(:expense, amount: 30.00) }
    let(:users) { create_list(:user, 3) }

    describe '#split_equally_among' do
      it 'creates expense shares for all users' do
        expect do
          expense.split_equally_among(users)
        end.to change(ExpenseShare, :count).by(3)
      end

      it 'splits amount equally among users' do
        expense.split_equally_among(users)
        expense.expense_shares.each do |share|
          expect(share.amount_owed).to eq(10.00)
        end
      end

      it 'does nothing with empty user array' do
        expect do
          expense.split_equally_among([])
        end.not_to change(ExpenseShare, :count)
      end
    end

    describe '#total_shared_amount' do
      it 'returns sum of all expense shares' do
        expense.split_equally_among(users)
        expect(expense.total_shared_amount).to eq(30.00)
      end
    end

    describe '#remaining_to_split' do
      it 'returns difference between total and shared amount' do
        # Create partial shares manually (not using split_equally_among)
        ExpenseShare.create!(expense: expense, user: users.first, amount_owed: 10.00)
        ExpenseShare.create!(expense: expense, user: users.second, amount_owed: 5.00)

        expect(expense.remaining_to_split).to eq(15.00) # 30 - 15 = 15
      end

      it 'returns zero when fully split' do
        expense.split_equally_among(users)
        expect(expense.remaining_to_split).to eq(0.00)
      end
    end
  end
end
