namespace :scraper do
  task create_course: :environment do
    require_relative '../scraper/new_website_scraper'

    courses = DeAnzaScraper::NewWebsiteScraper.new.scrape('S2018')

    Course.transaction do
      courses.each do |c|
        if course = Course.find_by(crn: c[:crn])
          course.update(c)
        else
          Course.create(c)
        end
      end
    end
  end
end
