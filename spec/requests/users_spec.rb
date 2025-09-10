require 'rails_helper'

RSpec.describe '/users', type: :request do
  describe 'GET /users' do
    it 'renders a successful response' do
      create(:user)
      get users_url
      expect(response).to be_successful
    end
  end

  describe 'GET /users/:id' do
    it 'renders a successful response' do
      user = create(:user)
      get user_url(user)
      expect(response).to be_successful
    end
  end

  describe 'GET /users/new' do
    it 'renders a successful response' do
      get new_user_url
      expect(response).to be_successful
    end
  end

  describe 'POST /users' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post users_url, params: { user: { name: 'Jane', email: 'jane@example.com' } }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post users_url, params: { user: { name: 'Jane', email: 'jane@example.com' } }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post users_url, params: { user: { name: '', email: '' } }
        end.to change(User, :count).by(0)
      end

      it 'renders the new template' do
        post users_url, params: { user: { name: '', email: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
