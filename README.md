# README

# WeatherApp

A Ruby on Rails application that fetches real-time weather data from the [AccuWeather API]
(https://developer.accuweather.com/).  

The app accepts a postal code, retrieves current weather conditions and forecast, and displays them.

# Features

 Search by postal code
- Fetch weather from AccuWeather API using `httparty` gem
- Display current conditions and daily forecast
- Caching for 30 minutes per postal code
- Indicator if results are served from cache
- Styled with TailwindCSS
- Fully tested with RSpec

# Technologies used

- Ruby on Rails 7
- TailwindCSS
- HTTParty
- RSpec + WebMock for testing


## set-up

> git clone https://github.com/ravi-harinath/weather_app.git
> cd weather_app

# Create a .env file in the project root:

ACCUWEATHER_API_KEY=api_key

replace api_key with your key

A weather API key from [AccuWeather](https://developer.accuweather.com/). They have a [free tier](https://developer.accuweather.com/packages) that allows you to send 50 requests a day.


> bundle install

# Run the server

> rails server

Visit http://localhost:3000

# Running Tests

> bundle exec rspec



