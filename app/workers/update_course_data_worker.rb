class UpdateCourseDataWorker
  include Sidekiq::Worker

  def perform(*args)
    begin
      require_relative '../../lib/scraper/myportal_scraper'
      termcode = Rails.application.credentials.termcode
      quarter  = Rails.application.credentials.quarter
      course_data = DeAnzaScraper::MyportalScraper.new.scrape(termcode)

      Course.transaction do
        course_data.each do |data|
          if course = Course.find_by(crn: data[:crn], quarter: quarter)
            course.attributes = data

            if course.changed.include?('status')
              course.subscribers.each do |user|
                UserMailer.notify_status_change(user, course, course.status_was, course.status).deliver_later!
              end
            end

            course.save if course.changed?
          else
            Course.create(data)
          end
        end
      end
    end
  rescue Exception => e
    # prvent any exception. do not retry
    # still need to send error to rollbar
    Rollbar.error(e)
  end
end
