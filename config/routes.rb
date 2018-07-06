Rails.application.routes.draw do
  devise_for :users

  #
  # All users
  #
  root to: 'home#index'
  resources :courses, only: [:index, :show] do
    resources :lessons, only: [:index, :show], shallow: true
  end

  #
  # Course master
  # 
  namespace :course_master do
    get '/', to: 'home#index'
    resources :courses do
      resources :lessons, shallow: true
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
