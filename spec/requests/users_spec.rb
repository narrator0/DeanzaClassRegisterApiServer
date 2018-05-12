require 'rails_helper'

RSpec.describe 'User API', type: :request do
  let(:user_attributes) { attributes_for(:user) }

  describe 'POST /signup' do
    context 'when valid user' do
      before { post '/signup', params: { user: user_attributes } }

      it 'creates a new user' do
        expect(User.last.email).to eq(user_attributes[:email])
      end

      it 'responds 201' do
        expect(response).to have_http_status(201)
      end
    end
  end
end
