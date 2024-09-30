module RapidApiClient
  def request_tiktok_api(url)
    response = Excon.get(
      url,
      headers: {
        'X-RapidAPI-Host' => Rails.application.credentials[Rails.env.to_sym].dig(:rapidapi, :tiktok_url_host),
        'X-RapidAPI-Key' => Rails.application.credentials[Rails.env.to_sym].dig(:rapidapi, :tiktok_rapidapi_key)
      }
    )
    return nil if response.status != 200
    JSON.parse(response.body)
  end

  def find_tiktok_video(term)
    request_tiktok_api(
      "https://#{Rails.application.credentials[Rails.env.to_sym].dig(:rapidapi, :tiktok_url_host)}/feed/search?keywords=#{term}&region=us&count=10&cursor=0&publish_time=0&sort_type=0"
    )
  end
end