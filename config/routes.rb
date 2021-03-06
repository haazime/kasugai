Rails.application.routes.draw do
  root to: 'home#show'

  get '/sign_up/:token', to: 'users#create', as: :verify_sign_up
  resources :sign_ups, param: :token, only: [:new, :create]

  get '/sign_in/:token', to: 'sessions#create', as: :sign_in
  resources :sign_ins, only: [:new, :create]

  delete '/sign_out', to: 'sessions#destroy', as: :sign_out

  resource :account, only: [:show, :destroy]
  get '/home', to: 'home#show', as: :home

  resources :projects

  resource :timeline, only: [:show]

  scope '/projects/:project_id', as: :project, module: :project do
    resources :issues
    resources :bookmarked_issues, only: [:index, :create, :destroy]
    resources :members, only: [:index, :new, :create, :destroy]
    resources :closed_issues, only: [:index, :create, :destroy]
  end

  scope '/issues/:issue_id', as: :issue, module: :issue do
    resource :priority, only: [:update]
    resources :comments, only: [:index, :create, :edit, :update, :destroy]
  end

  get '/profile/edit', to: 'profile#edit', as: :edit_profile
  patch '/profile', to: 'profile#update', as: :profile
  patch '/profile/theme', to: 'profile/theme#update', as: :profile_theme

  if Rails.env.development?
    resources :backdoors, only: [:index, :create]
  end
end
