Rails.application.routes.draw do
  devise_for :users

  concern :home do
    get '/', to: 'home#index'
  end

  #
  # All users
  #
  root to: 'home#index'
  resources :courses, only: %i(index show) do
    resources :lessons, only: %i(index show), shallow: true
  end

  resources :course_passages, path: :my_courses do
    resources :lesson_passages, path: :lesson, only: :show, as: :lesson
  end

  #
  # Course master
  # 
  namespace :course_master do
    concerns :home
    resources :courses do
      resources :lessons, shallow: true do
        resources :quests, shallow: true
        resources :materials, shallow: true
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
