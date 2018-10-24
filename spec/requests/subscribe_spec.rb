require 'rails_helper'

RSpec.describe 'Subscribe API', type: :request do
  let(:user) { create(:user) }
  let(:auth_token) { JsonWebToken.encode(user_id: user.id) }
  let(:header) { { 'Authorization' => auth_token } }
  let(:course) { create(:course) }

  # todo: refactor duplicate tests
  describe 'POST /subscribe' do
    context 'subscribe when course is not subscribed' do
      before {
        post '/subscribe',
        params: {
          crn: course.crn,
          type: 'subscribe',
        },
        headers: header
      }

      it 'should responds 200' do
        expect(response).to have_http_status(200)
      end

      it 'should subscribe to all of the courses' do
        expect(user.subscribe_courses.length).to eq(1)
      end

      it 'response all the ids subscribed' do
        expect(json.length).to eq(1)
      end
    end

    context 'subscribe when course is already subscribed' do
      before { user.subscribe_courses << course }
      before {
        post(
          '/subscribe',
          params: {
            crn: course.crn,
            type: 'subscribe',
          },
          headers: header
        )
      }

      it 'should respond 200' do
         expect(response).to have_http_status(200)
       end

      it 'should unsubscribe' do
        expect(user.reload.subscribe_courses.length).to eq(0)
      end
    end

    context 'like when course is not subscribed' do
      before {
        post '/subscribe',
        params: {
          crn: course.crn,
          type: 'like',
        },
        headers: header
      }

      it 'should responds 200' do
        expect(response).to have_http_status(200)
      end

      it 'should subscribe to all of the courses' do
        expect(user.like_courses.length).to eq(1)
      end

      it 'response all the ids subscribed' do
        expect(json.length).to eq(1)
      end
    end

    context 'like when course is already subscribed' do
      before { user.like_courses << course }
      before {
        post(
          '/subscribe',
          params: {
            crn: course.crn,
            type: 'like',
          },
          headers: header
        )
      }

      it 'should respond 200' do
         expect(response).to have_http_status(200)
       end

      it 'should unsubscribe' do
        expect(user.reload.like_courses.length).to eq(0)
      end
    end

    context 'add to calendar when course is not subscribed' do
      before {
        post '/subscribe',
        params: {
          crn: course.crn,
          type: 'calendar',
        },
        headers: header
      }

      it 'should responds 200' do
        expect(response).to have_http_status(200)
      end

      it 'should subscribe to all of the courses' do
        expect(user.calendar_courses.length).to eq(1)
      end

      it 'response all the ids subscribed' do
        expect(json.length).to eq(1)
      end
    end

    context 'add to calendar when course is already subscribed' do
      before { user.calendar_courses << course }
      before {
        post(
          '/subscribe',
          params: {
            crn: course.crn,
            type: 'calendar',
          },
          headers: header
        )
      }

      it 'should respond 200' do
         expect(response).to have_http_status(200)
       end

      it 'should unsubscribe' do
        expect(user.reload.calendar_courses.length).to eq(0)
      end
    end
  end
end
