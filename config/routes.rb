Rails.application.routes.draw do
  devise_for :users

  concern :home do
    get '/', to: 'home#index'
  end

  #
  # All users
  #
  root to: 'home#index'
  resources :courses, only: %i(index show), shallow: true do
    resources :lessons, only: %i(index show)
  end

  resources :course_passages, path: :my_courses do
    resources :lesson_passages, path: :lessons, only: :show, as: :lesson
    resources :quest_passages, only: :show do
      resource :quest_solutions, path: :solutions, only: :create
    end
  end

  #
  # Course master
  # 
  namespace :course_master do
    concerns :home
    resources :courses do
      resources :lessons, shallow: true do
        resources :quests
        resources :materials
      end
      resources :course_passages, only: %i(index show) do
        resources :quest_passages, only: :show
      end
    end
    resources :quest_solutions, only: %i(index show) do
      member do
        patch :accept
        patch :decline
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
