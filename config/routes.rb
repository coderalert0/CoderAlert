Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => 'users/registrations',
                                      invitations: 'users/invitations',
                                      sessions: 'users/sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'dashboard#show'

  resources :projects, path: 'p'

  resources :articles, path: 'kb' do
    resources :comments
  end

  resources :tickets, path: 't' do
    resources :comments
  end

  resources :project_users, path: 'pu'

  resources :schedules, path: 's'

  resources :contacts, path: 'c'

  resource :active_project, :controller => 'active_project', path: 'ap'

  resources :after_signup, path: 'welcome'

end
