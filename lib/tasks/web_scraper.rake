namespace :scraper do
  # todo: use yml files for quarter and tercodes
  desc 'setup task: get all the course data for the first time'
  task create_course: :environment do
    require_relative '../scraper/new_website_scraper'
    require_relative '../scraper/myportal_scraper'

    def update_course_with_scraper(title)
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

          if course = Course.find_by(crn: data[:crn])
            course.lectures.delete_all
            course.update(data)
          else
            Course.create(data)
          end
        end
      end

      # end progressbar and print finish prompt
      progressbar.finish
    end

    # get course data from www.deanza.edu
    update_course_with_scraper('Updating database') do
      DeAnzaScraper::NewWebsiteScraper.new.scrape('M2018')
    end

    # get course data from myportal
    update_course_with_scraper('Updating database') do
      DeAnzaScraper::MyportalScraper.new.scrape('201912')
    end

    puts 'Update course data successfully.'
  end
end
