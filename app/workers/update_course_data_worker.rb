class UpdateCourseDataWorker
  include Sidekiq::Worker

  def perform(*args)
    require_relative '../../lib/scraper/myportal_scraper'
    course_data = DeAnzaScraper::MyportalScraper.new.scrape('201912')

    # setup progressbar
    progressbar = ProgressBar.create(
      title: 'update course data...',
      total: course_data.count,
      format: '%t: |%B%p%|'
    )

    Course.transaction do
      course_data.each do |data|
        progressbar.increment

        if course = Course.find_by(crn: data[:crn], quarter: 'M2018')

          if data['lectures_attributes'].present?
            data['lectures_attributes'].each do |lecture|
              lecture[:id] = course.lectures.find_by(title: lecture[:title]).try(:id)
            end
          end

          course.update(data)
        else
          Course.create(data)
        end
      end
    end

    progressbar.finish
  end
end
