require_relative './new_website_scraper'
require_relative './myportal_scraper'

class DeAnzaScraper
  def self.create_course
    # get course data from www.deanza.edu
    update_course_with_scraper('Updating database') do
      DeAnzaScraper::NewWebsiteScraper.new.scrape(Rails.application.credentials.quarter)
    end

    # get course data from myportal
    update_course_with_scraper('Updating database') do
      DeAnzaScraper::MyportalScraper.new.scrape(Rails.application.credentials.termcode)
    end
  end

  def self.update_myportal_data
    course_data = DeAnzaScraper::MyportalScraper.new.scrape(termcode)
    self.update_database(course_data)
  end

  def self.update_course_with_scraper(title)
    course_data = yield

    # setup progressbar
    progressbar = ProgressBar.create(
      title: title,
      total: course_data.count,
      format: '%t: |%B%p%|'
    )

    # update course in the database
    Course.transaction do
      course_data.each do |data|
        progressbar.increment

        if course = Course.find_by(crn: data[:crn], quarter: Rails.application.credentials.quarter)

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

    # end progressbar and print finish prompt
    progressbar.finish
  end

  def self.update_database(course_data)
    termcode = Rails.application.credentials.termcode
    quarter  = Rails.application.credentials.quarter

    Course.transaction do
      course_data.each do |data|
        if course = Course.find_by(crn: data[:crn], quarter: quarter)
          course.attributes = data

          if course.changed.include?('status')
            course.subscribers.each do |user|
              user.course_status_update_notifications.create(
                message: "The class #{course.course} that you've subscribed to has changed its status from #{course.status_was} to #{course.status}",
                course_id: course.id
              )

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
end

