# app/workers/find_tiktok_buzzes_daily_worker.rb

class FindTiktokBuzzesDailyWorker
  include Sidekiq::Worker

  def perform
    FindTiktokBuzzes.find_tiktok_buzzes_daily
  end
end