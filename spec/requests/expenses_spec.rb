require 'rails_helper'

RSpec.describe '/expenses', type: :request do
  let(:user) { create(:user) }

  describe 'GET /expenses' do
    it 'renders a successful response' do
      create(:expense)
      get expenses_url
      expect(response).to be_successful
    end
  end

  describe 'POST /expenses' do
    context 'with valid parameters' do
      it 'creates a new Expense' do
        expect do
          post expenses_url, params: {
            expense: {
              description: 'Dinner',
              amount: 30.00,
              date: Date.today,
              paid_by_id: user.id
            }
          }
        end.to change(Expense, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Expense' do
        expect do
          post expenses_url, params: {
            expense: {
              description: '',
              amount: -5
            }
          }
        end.to change(Expense, :count).by(0)
      end
    end
  end
end
