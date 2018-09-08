Rails.application.routes.draw do
  devise_for :users

  concern :home do
    get '/', to: 'home#index'
  end

  concern :passable do |options|
    member do
      post :learn, action: :learn!
    end
  end

  concern :badgable do
    resources :badges, only: %i(create new)
  end

  #
  # Statistics
  #
  concern :user_statisticable do
    scope :statistics do
      get :courses_progress, action: :courses_progress
      get :lessons_progress, action: :lessons_progress
      get :quests_progress,  action: :quests_progress
      get :top_three_knowledges, action: :top_three_knowledges
      get :knowledges_directions, action: :knowledges_directions
    end
  end

  #
  # All users
  #
  root to: 'home#index'
  resources :users, only: %i(show update) do
    member do
      get :badges, action: :show_badges
      get :knowledges, action: :show_knowledges
      get :courses, action: :show_courses
    end
    concerns :user_statisticable
  end

  resources :courses, only: %i(index show), shallow: true do
    concerns :passable
    resources :lessons, only: %i(index show)
  end

  #
  # Passages
  #
  resources :passages, only: %i(show), shallow: true do
    resources :solutions, controller: :passage_solutions, only: :create
    member do
      patch :try_pass
    end
  end

  #
  # Course master
  # 
  namespace :course_master do
    concerns :home
    resources :badges, only: %i(edit update destroy)

    resources :courses, except: :show do
      concerns :badgable
      resources :lessons, except: %i(show index), shallow: true do
        resources :quests, except: %i(show index) do
          concerns :badgable
        end
        resources :materials, except: %i(show index)
      end
    end

    resources :solutions, controller: :passage_solutions, only: %i(index show) do
      member do
        patch :accept
        patch :decline
      end
    end

    resources :knowledge_directions, only: :create
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
