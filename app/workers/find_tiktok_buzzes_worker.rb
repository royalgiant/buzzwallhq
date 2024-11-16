# app/workers/find_tiktok_buzzes_worker.rb
require 'rapid_api_client'

class FindTiktokBuzzesWorker
  include Sidekiq::Worker
  
  def perform(buzz_term_id, frequency = nil, sort_type = 3)
    buzz_term = BuzzTerm.find(buzz_term_id)
    frequency_check = frequency.present? ? frequency : buzz_term.get_tiktok_publish_time
    results = RapidApiClient.find_tiktok_video(buzz_term.term, frequency_check, sort_type)
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
        buzz.full_video_data = video_data
        buzz.buzz_term_id = buzz_term.id
        buzz.approved = false
      end
      Rails.logger.info("New Buzz ID: #{buzz.id}")
    end
    
    play_count_over_1m = Buzz.where("play_count > ?", 1_000_000).count
    play_count_over_100k = Buzz.where("play_count > ? AND play_count < ?", 100_000, 1_000_000).count

    BuzzMailer.with(user_id: buzz_term.user_id, play_count_over_1m: play_count_over_1m, play_count_over_100k: play_count_over_100k).viral_videos_found.deliver_now
  end
end