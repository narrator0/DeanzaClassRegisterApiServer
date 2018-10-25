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

  describe 'PATCH /users' do
    let(:user) { create(:user) }
    let(:auth_token) { JsonWebToken.encode(user_id: user.id) }
    let(:header) { { 'Authorization' => auth_token } }

    context 'with valid data' do
      before { patch '/users', params: { user: { password: 'changed' } }, headers: header }

      it 'response 202 accepted' do
        expect(response).to have_http_status(202)
      end

      it 'changes the password' do
        expect(User.last.valid_password?('changed')).to be_truthy
      end
    end

    context 'without valid data' do
      it 'response 422 without a token' do
        patch '/users', params: { user: { password: 'changed' } }
        expect(response).to have_http_status(422)
      end

      it 'response 422 if token is invalid' do
        patch '/users', params: { user: { password: 'changed' } }, headers: { 'Authorization': 'auth' }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET #notifications' do
    let(:user) { create(:user) }
    let(:course) { create(:course) }

    context 'when logged in' do
      let(:auth_token) { JsonWebToken.encode(user_id: user.id) }
      let(:header) { { 'Authorization' => auth_token } }

      before {
        user.course_status_update_notifications.create(message: 'test', course_id: course.id)
        get '/user/notifications', headers: header
      }

      it 'response 200' do
        expect(response).to have_http_status(200)
      end

      it 'response all the notifications' do
        expect(json.length).to eq(1)
      end
    end

    context 'when not logged in' do
      before {
        user.course_status_update_notifications.create(message: 'test', course_id: course.id)
        get '/user/notifications'
      }

      it 'response 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
