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

  describe 'GET /courses with params' do
    it 'response to `dept` params' do
      get '/courses', params: { dept: 'CIS' }
      expect(json['total']).to eq(20)

      get '/courses', params: { dept: 'ACCT' }
      expect(json['total']).to eq(0)
    end

    it 'response to `qaurter` params' do
      get '/courses', params: { quarter: 'M2018' }
      expect(json['total']).to eq(20)

      get '/courses', params: { quarter: 'S2018' }
      expect(json['total']).to eq(0)
    end
  end
end
