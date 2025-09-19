Rails.application.routes.draw do
  resources :messages, only: [:index, :create]
  post "/webhook/n8n_response", to: "webhook#n8n_response"
  root "messages#index"
end