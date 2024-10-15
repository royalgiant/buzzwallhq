# app/workers/find_tiktok_buzzes_monthly_worker.rb

class FindTiktokBuzzesMonthlyWorker
  include Sidekiq::Worker

  def perform
    FindTiktokBuzzes.find_tiktok_buzzes_monthly
  end
end