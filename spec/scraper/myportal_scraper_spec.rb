require 'rails_helper'
require_relative '../../lib/scraper/de_anza_scraper'

RSpec.describe DeAnzaScraper do
  describe '#get_course_status' do
    it 'should run without error' do
      create(:course)

      expect {
        DeAnzaScraper::NewWebsiteScraper.new.get_courses_status(Rails.application.credentials.quarter)
      }.to_not raise_error
    end
  end

  describe '#self.update_database' do
    before(:each) do
      Sidekiq::Worker.clear_all
    end
    let(:user) { create(:user) }
    before {
      @course = create(:course)
      user.subscribe_courses << @course
      @course.status = :Open
      course_hash = HashWithIndifferentAccess.new(@course.attributes.except('id'))
      DeAnzaScraper.update_database([course_hash])
    }

    it 'updates course data' do
      expect(Course.last.status).to eq('Open')
    end

    it 'creates a notification' do
      notifications = user.course_status_update_notifications
      expect(notifications.count).to eq(1)
      expect(notifications.last.message.match(/#{@course.course}/)).to be_truthy
    end

    it 'sends email to the user' do
      expect(Sidekiq::Worker.jobs.size).to eq(1)
    end
  end
end

