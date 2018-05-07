namespace :scraper do
  task create_course: :environment do
    require_relative '../scraper/new_website_scraper'
    courses = DeAnzaScraper::NewWebsiteScraper.new.scrape('S2018')
    Course.create courses
  end
end
