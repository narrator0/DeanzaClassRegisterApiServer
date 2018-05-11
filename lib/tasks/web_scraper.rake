namespace :scraper do
  # todo: use yml files for quarter and tercodes
  desc 'setup task: get all the course data for the first time'
  task create_course: :environment do
    require_relative '../scraper/new_website_scraper'

    # get course data from www.deanza.edu
    courses = DeAnzaScraper::NewWebsiteScraper.new.scrape('S2018')

    # setup progressbar
    progressbar = ProgressBar.create(
      title: 'Updating database',
      total: courses.count,
      format: '%t: |%B%p%|'
    )

    # update course in the database
    Course.transaction do
      courses.each do |c|
        progressbar.increment

        if course = Course.find_by(crn: c[:crn])
          course.lectures.delete_all
          course.update(c)
        else
          Course.create(c)
        end
      end
    end

    # end progressbar and print finish prompt
    progressbar.finish
    puts 'Update course data successfully.'
  end
end
