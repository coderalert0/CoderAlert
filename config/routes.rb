Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => 'users/registrations',
                                      invitations: 'users/invitations',
                                      sessions: 'users/sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'dashboard#show'

  resources :projects, path: 'p', except: :destroy do
    resources :schedules, path: 's'
    resources :alert_settings, path: 'as'

    resources :articles, path: 'kb' do
      resources :comments
    end

    resources :tickets, path: 't', except: :destroy do
      resources :comments
      put '/status', to: 'ticket_status#update'
    end

    resources :project_users, path: 'pu'

    resources :users, path: 'u', only: :show
  end

  resources :contacts, path: 'c'

  resource :active_project, :controller => 'active_project', path: 'ap'

  resources :after_signup, path: 'welcome'

  get '/slack_auth/callback', to: 'slack_authorization#callback'

end
