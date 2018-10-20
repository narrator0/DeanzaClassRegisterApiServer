namespace :scraper do
  desc 'setup task: get all the course data for the first time'
  task create_course: :environment do
    require_relative '../scraper/de_anza_scraper'
    DeAnzaScraper.create_course

    puts 'Update course data successfully.'
  end
end
