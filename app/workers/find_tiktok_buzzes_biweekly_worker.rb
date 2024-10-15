# app/workers/find_tiktok_buzzes_biweekly_worker.rb

class FindTiktokBuzzesBiweeklyWorker
  include Sidekiq::Worker

  def perform
    FindTiktokBuzzes.find_tiktok_buzzes_biweekly
  end
end