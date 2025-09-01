class WeatherController < ApplicationController
  def index
  end

  def show
    query = params[:postal_code].presence || params[:address].presence

    if query.blank?
      flash.now[:alert] = "Please provide a postal code or address."
      render :index and return
    end

    begin
      client = AccuWeatherClient.new(api_key: ENV["ACCUWEATHER_API_KEY"])
      cache_key = "weather:#{query.downcase.strip}"

      cached = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
        data = client.fetch_current_and_forecast(query)
        { data: data, from_cache: false, fetched_at: Time.current }
      end

      cached_obj = Rails.cache.read(cache_key)
      if cached_obj && cached_obj[:was_cached]
        @from_cache = true
      else
        Rails.cache.write(cache_key, cached.merge(was_cached: true), expires_in: 30.minutes)
        @from_cache = false
      end

      @weather = cached[:data]
      @query = query
      render :show
    rescue AccuWeatherClient::Error => e
      flash.now[:alert] = "Error fetching weather: #{e.message}"
      render :index
    end
  end
end
