class FindTiktokVideoJob < ApplicationJob
  queue_as :default

  def perform(buzz_term)
    results = RapidApiClient.find_tiktok_video(buzz_term.term)
    data = results["data"]["videos"]
    data.each do |video_data|
      Buzz.create!(
        video_id: video_data["video_id"],
        title: video_data["title"],
        thumbnail_url: video_data["ai_dynamic_cover"],
        url: video_data["wmplay"],
        play_count: video_data["play_count"],
        comment_count: video_data["comment_count"],
        share_count: video_data["share_count"],
        create_time: Time.at(video_data["create_time"]),
        author: video_data["author"],
        user_id: buzz_term.user_id,
        buzz_term_id: buzz_term.id,
        approved: false
      )
    end
  end
end
