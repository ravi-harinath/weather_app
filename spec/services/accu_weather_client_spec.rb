require 'rails_helper'

RSpec.describe AccuWeatherClient do
  let(:client) { described_class.new(api_key: 'fake_key') }

  before do
    stub_request(:get, /dataservice.accuweather.com/).to_return do |request|
      if request.uri.path.start_with?('/locations/v1/postalcodes/search')
        { status: 200, body: [ { "Key" => "123", "LocalizedName" => "Test City", "Country" => { "LocalizedName" => "Testland" } } ].to_json }
      elsif request.uri.path.start_with?('/currentconditions/v1/')
        { status: 200, body: [ { "WeatherText" => "Sunny", "Temperature" => { "Metric" => { "Value" => 25 } }, "RealFeelTemperature" => { "Metric" => { "Value" => 27 } } } ].to_json }
      elsif request.uri.path.start_with?('/forecasts/v1/daily/1day/')
        { status: 200, body: { "DailyForecasts" => [ { "Temperature" => { "Maximum" => { "Value" => 30 }, "Minimum" => { "Value" => 20 } }, "Day" => { "IconPhrase" => "Sunny" }, "Night" => { "IconPhrase" => "Clear" } } ] }.to_json }
      else
        { status: 404, body: '{}' }
      end
    end
  end

  it 'fetches location, current conditions and forecast' do
    result = client.fetch_current_and_forecast('12345')
    expect(result[:location]['Key']).to eq('123')
    expect(result[:current]['WeatherText']).to eq('Sunny')
    expect(result[:daily]['DailyForecasts'].first['Temperature']['Maximum']['Value']).to eq(30)
  end
end
