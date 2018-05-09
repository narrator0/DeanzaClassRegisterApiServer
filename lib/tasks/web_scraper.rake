namespace :scraper do
  task create_course: :environment do
    require_relative '../scraper/new_website_scraper'

    courses = DeAnzaScraper::NewWebsiteScraper.new.scrape('S2018')

    progressbar = ProgressBar.create(
      title: 'Updating database',
      total: courses.count,
      format: '%t: |%B%p%|'
    )

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

    progressbar.finish
    puts 'Update course data successfully.'
  end
end
