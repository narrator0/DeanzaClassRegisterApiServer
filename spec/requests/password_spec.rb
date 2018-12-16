require 'rails_helper'

RSpec.describe 'Password Reset', type: :request do
  let(:user) { create(:user) }

  describe 'POST /users/password' do
    context 'when correct email' do
      before {
        post '/users/password', params: { user: { email: user.email } }
      }

      it 'sends an email' do
        expect(Sidekiq::Worker.jobs.size).to eq(1)
      end

      it 'response 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when incorrect email' do
      before {
        post '/users/password'
      }

      it 'response 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end

