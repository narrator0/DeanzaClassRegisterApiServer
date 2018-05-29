class UpdateCourseDataWorker
  include Sidekiq::Worker

  def perform(*args)
    require_relative '../../lib/scraper/myportal_scraper'
    course_data = DeAnzaScraper::MyportalScraper.new.scrape('201912')

    Course.transaction do
      course_data.each do |data|
        if course = Course.find_by(crn: data[:crn], quarter: 'M2018')
          course.attributes = data

          course.save if course.changed?
        else
          Course.create(data)
        end
      end
    end
  end
end
