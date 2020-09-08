Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'dashboard#show'

  resources :projects do
    resources :tickets
    resources :articles
    resources :users, :controller => :project_users
  end

end
