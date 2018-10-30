class UpdateCourseDataWorker
  include Sidekiq::Worker

  def perform(*args)
    begin
      require_relative '../../lib/scraper/de_anza_scraper'
      DeAnzaScraper.update_myportal_data
    rescue Exception => e
      # prvent any exception. do not retry
      # still need to send error to rollbar and sentry
      Rollbar.error(e)
      Raven.capture_exception(e)
    end
  end
end
