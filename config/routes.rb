Rails.application.routes.draw do
  # get 'home/index'
  # get 'home/services'
  # get 'home/projects'
  # get 'home/pricing'
  # get 'home/contacts'
  # get 'home/abouat'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  post 'home/contacts', to: 'home#contacts'
  get '/curriculum', to: 'home#curriculum'
  get '/pricing', to: 'home#pricing'
  get '/blog', to: 'home#blog'
end
