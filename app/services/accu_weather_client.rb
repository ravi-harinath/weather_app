require "httparty"

class AccuWeatherClient
  include HTTParty
  base_uri "http://dataservice.accuweather.com"

  class Error < StandardError; end

  def initialize(api_key:)
    @api_key = api_key || ENV["ACCUWEATHER_API_KEY"]
    raise Error, "AccuWeather API key not configured" if @api_key.nil? || @api_key.empty?
  end

  def fetch_current_and_forecast(query)
    location = find_location(query)
    raise Error, "Location not found" if location.nil?

    location_key = location["Key"]
    {
      location: location,
      current: current_conditions(location_key),
      daily: daily_forecast(location_key)
    }
  end

  private

  def find_location(query)
    postal_resp = self.class.get("/locations/v1/postalcodes/search", query: { apikey: @api_key, q: query })
    return postal_resp.parsed_response.first if postal_resp.success? && postal_resp.parsed_response.any?

    city_resp = self.class.get("/locations/v1/cities/search", query: { apikey: @api_key, q: query })
    return city_resp.parsed_response.first if city_resp.success? && city_resp.parsed_response.any?

    nil
  end

  def current_conditions(location_key)
    resp = self.class.get("/currentconditions/v1/#{location_key}", query: { apikey: @api_key, details: true })
    raise Error, "Unable to fetch current conditions" unless resp.success? && resp.parsed_response.is_a?(Array)
    resp.parsed_response.first
  end

  def daily_forecast(location_key)
    resp = self.class.get("/forecasts/v1/daily/1day/#{location_key}", query: { apikey: @api_key, metric: true })
    raise Error, "Unable to fetch forecast" unless resp.success?
    resp.parsed_response
  end
end
