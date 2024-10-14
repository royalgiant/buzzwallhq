# lib/rapid_api_client.rb
module RapidApiClient
  def self.request_tiktok_api(url)
    response = Excon.get(
      url,
      headers: {
        'X-RapidAPI-Host' => Rails.application.credentials.dig(Rails.env.to_sym, :rapidapi, :tiktok_url_host),
        'X-RapidAPI-Key' => Rails.application.credentials.dig(Rails.env.to_sym, :rapidapi, :tiktok_rapidapi_key)
      }
    )
    return nil if response.status != 200
    JSON.parse(response.body)
  end

  def self.find_tiktok_video(term, frequency)
    request_tiktok_api(
      "https://#{Rails.application.credentials.dig(Rails.env.to_sym, :rapidapi, :tiktok_url_host)}/feed/search?keywords=#{term}&region=us&count=10&cursor=0&publish_time=#{frequency}&sort_type=3"
    )
  end
end