Rails.application.routes.draw do
  resources :companies, format: :json
  resources :employees, format: :json
end
