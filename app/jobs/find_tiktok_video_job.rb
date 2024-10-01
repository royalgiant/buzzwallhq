class FindTiktokVideoJob < ApplicationJob
  queue_as :default

  def perform(term)
    RapidApiClient.find_tiktok_video(term)
  end
end
