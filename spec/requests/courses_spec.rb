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
      get '/courses', params: { quarter: Rails.application.credentials.quarter }
      expect(json['total']).to eq(20)

      get '/courses', params: { quarter: 'S2011' }
      expect(json['total']).to eq(0)
    end
  end

  describe 'GET courses#show' do
    before {
      get "/courses/#{courses.first.id}"
    }

    it 'response 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET courses#quarters' do
    before {
      create(:course)
      get '/courses/quarters'
    }

    it 'response 200' do
      expect(response).to have_http_status(200)
    end

    it 'response all quarters' do
      expect(json[0]).to eq(Rails.application.credentials.quarter)
    end
  end
end
