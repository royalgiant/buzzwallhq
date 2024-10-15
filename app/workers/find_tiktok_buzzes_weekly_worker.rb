# app/workers/find_tiktok_buzzes_weekly_worker.rb

class FindTiktokBuzzesWeeklyWorker
  include Sidekiq::Worker

  def perform
    FindTiktokBuzzes.find_tiktok_buzzes_weekly
  end
end