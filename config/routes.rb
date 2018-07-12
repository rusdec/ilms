Rails.application.routes.draw do
  devise_for :users

  concern :home do
    get '/', to: 'home#index'
  end

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
    concerns :home
    resources :courses do
      resources :lessons, shallow: true
    end

    resources :quests, shallow: true do
      collection do
        get 'used'
        get 'unused'
      end
    end
  end

  #
  # Administrator
  #
  namespace :administrator do
    concerns :home
    resources :users, shallow: true
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
