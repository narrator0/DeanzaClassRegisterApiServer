require 'rails_helper'

RSpec.describe 'Notification API', type: :request do
  describe 'PATCH /notification/read' do
    let(:notification) { create(:course_status_update_notification) }

    context 'when logged in' do
      let(:auth_token) { JsonWebToken.encode(user_id: notification.user.id) }
      let(:header) { { 'Authorization' => auth_token } }

      before {
        patch "/notification/#{notification.id}/read", headers: header
      }

      it 'response 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates read and read_at' do
        expect(notification.reload.read).to be_truthy
        expect(notification.reload.read_at).to be_truthy
      end
    end

    context 'when not logged in' do
      before {
        patch "/notification/#{notification.id}/read"
      }

      it 'response 422' do
        expect(response).to have_http_status(422)
      end
    end

    context 'notification not found' do
      let(:auth_token) { JsonWebToken.encode(user_id: notification.user.id) }
      let(:header) { { 'Authorization' => auth_token } }

      before {
        patch "/notification/100/read", headers: header
      }

      it 'response 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'PATCH /notificaation/readAll' do
    let(:user) { create(:user) }
    before {
      create_list(:course_status_update_notification, 3, user: user)
    }

    context 'when logged in' do
      let(:auth_token) { JsonWebToken.encode(user_id: user.id) }
      let(:header) { { 'Authorization' => auth_token } }

      before {
        patch '/notification/readAll', headers: header
      }

      it 'response 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates all the notifications to read' do
        expect(Notification.pluck(:read)).to eq([true, true, true])
      end
    end

    context 'when not logged in' do
      before {
        patch '/notification/readAll'
      }

      it 'response 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end

