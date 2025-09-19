Rails.application.routes.draw do
  resources :dialogs, only: [ :index, :show, :create ] do
    resources :messages, only: [ :create ]
  end

  # Отдельный маршрут для создания сообщения в новом диалоге
  post "/messages/create_with_dialog", to: "messages#create_with_dialog", as: :create_message_with_dialog

  post "/webhook/n8n_response", to: "webhook#n8n_response"

  root "dialogs#index"
end
