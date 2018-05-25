require 'rails_helper'

RSpec.describe 'Subscribe API', type: :request do
  let(:user) { create(:user) }
  let(:auth_token) { JsonWebToken.encode(user_id: user.id) }
  let(:header) { { 'Authorization' => auth_token } }
  let(:course) { create(:course) }

  describe 'POST /subscribe' do
    context 'when course is not subscribed' do
      before {
        post '/subscribe',
        params: {
          crn: course.crn
        },
        headers: header
      }

      it 'should responds 200' do
        expect(response).to have_http_status(200)
      end

      it 'should subscribe to all of the courses' do
        expect(user.subscribed_courses.length).to eq(1)
      end

      it 'response all the ids subscribed' do
        expect(json.length).to eq(1)
      end
    end

    context 'when course is already subscribed' do
      before { user.subscribed_courses << course }
      before {
        post(
          '/subscribe',
          params: { crn: course.crn },
          headers: header
        )
      }

      it 'should respond 200' do
         expect(response).to have_http_status(200)
       end

      it 'should unsubscribe' do
        expect(user.reload.subscribed_courses.length).to eq(0)
      end
    end
  end
end
