Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => 'users/registrations', invitations: 'users/invitations'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'dashboard#show'

  resources :projects do
    resources :tickets do
      resources :comments
    end

    resources :articles do
      resources :comments
    end

    resources :users, :controller => :project_users

    resources :schedules
  end

end
