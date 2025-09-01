require 'rails_helper'
require 'webmock/rspec'

RSpec.describe AccuWeatherClient do
  let(:client) { described_class.new(api_key: 'fake_key') }

before do
    stub_request(:get, /locations\/v1\/postalcodes\/search/).
      to_return(
        status: 200,
        body: [
          { "Key" => "123", "LocalizedName" => "Test City", "Country" => { "LocalizedName" => "Testland" } }
        ].to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    stub_request(:get, /currentconditions\/v1\/123/).
      to_return(
        status: 200,
        body: [
          {
            "WeatherText" => "Cloudy",
            "Temperature" => { "Metric" => { "Value" => 18 } },
            "RealFeelTemperature" => { "Metric" => { "Value" => 17 } }
          }
        ].to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    stub_request(:get, /forecasts\/v1\/daily\/1day\/123/).
      to_return(
        status: 200,
        body: {
          "DailyForecasts" => [
            {
              "Temperature" => {
                "Maximum" => { "Value" => 22 },
                "Minimum" => { "Value" => 12 }
              },
              "Day" => { "IconPhrase" => "Partly sunny" },
              "Night" => { "IconPhrase" => "Clear" }
            }
          ]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end


  it 'fetches location, current conditions and forecast' do
    result = client.fetch_current_and_forecast("Test City")
    expect(result[:location]['LocalizedName']).to eq('123')
    expect(result[:current]['WeatherText']).to eq('Sunny')
    expect(result[:daily]['DailyForecasts'].first['Temperature']['Maximum']['Value']).to eq(30)
  end
end
