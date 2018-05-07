require 'rails_helper'

RSpec.describe 'Course API', type: :request do
  # initialize data
  let!(:courses) { create_list(:course, 20) }

  describe 'GET /courses' do
    before { get '/courses' }

    it 'response all the courses' do
      expect(json).not_to be_empty
      expect(json['total']).to eq(20)
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end
  end
end
