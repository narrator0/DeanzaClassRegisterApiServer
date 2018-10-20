class UpdateCourseDataWorker
  include Sidekiq::Worker

  def perform(*args)
    begin
      require_relative '../../lib/scraper/de_anza_scraper'
      DeAnzaScraper.update_myportal_data
    rescue Exception => e
      # prvent any exception. do not retry
      # still need to send error to rollbar
      Rollbar.error(e)
    end
  end
end
