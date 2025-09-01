Rails.application.routes.draw do
 root "weather#index"
  get "/weather", to: "weather#index"
  post "/weather", to: "weather#show"
end
