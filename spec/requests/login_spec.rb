require 'rails_helper'

RSpec.describe 'login API', type: :request do
  let(:user) { create(:user) }

  describe 'POST /login' do
    context 'when valid input' do
      before { post '/signin', params: {
        user: {
          email: user.email, password: 'password',
        }
      }}

      it 'responds 200' do
        expect(response).to have_http_status(200)
      end

      it 'responds a valid token' do
        expect(response_token[:user_id]).to eq(user.id)
      end
    end

    context 'when invalid input' do
      before { post '/signin', params: {
        user: {
          email: user.email, password: '',
        }
      }}

      it 'responds 401 unauthorized' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
