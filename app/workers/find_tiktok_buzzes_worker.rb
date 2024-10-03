# app/workers/find_tiktok_buzzes_worker.rb
require 'rapid_api_client'

class FindTiktokBuzzesWorker
  include Sidekiq::Worker
  
  def perform(buzz_term_id)
    buzz_term = BuzzTerm.find(buzz_term_id)
    frequency = buzz_term.get_tiktok_publish_time
    results = RapidApiClient.find_tiktok_video(buzz_term.term, frequency)
    data = results["data"]["videos"]
    data.each do |video_data|
      buzz = Buzz.find_or_create_by(video_id: video_data["video_id"], user_id: buzz_term.user_id) do |buzz|
        buzz.title = video_data["title"]
        buzz.thumbnail_url = video_data["ai_dynamic_cover"]
        buzz.url = "https://www.tiktok.com/embed/#{video_data['video_id']}"
        buzz.play_count = video_data["play_count"]
        buzz.comment_count = video_data["comment_count"]
        buzz.share_count = video_data["share_count"]
        buzz.create_time = Time.at(video_data["create_time"])
        buzz.author = video_data["author"]
        buzz.buzz_term_id = buzz_term.id
        buzz.approved = false
      end
      Rails.logger.info("New Buzz ID: #{buzz.id}")
    end
  end
end