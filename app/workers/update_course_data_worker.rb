class UpdateCourseDataWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(*args)
    require_relative '../../lib/scraper/de_anza_scraper'
    DeAnzaScraper.update_status
  end
end
