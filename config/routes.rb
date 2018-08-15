Rails.application.routes.draw do
  devise_for :users

  concern :home do
    get '/', to: 'home#index'
  end

  concern :passable do |options|
    member do
      post :learn, to: "#{options[:controller]}#learn!"
    end
    if options[:with_passages]
      collection do
        get 'passages/all', to: "#{options[:controller]}#passages"
      end
    end
  end

  #
  # All users
  #
  root to: 'home#index'
  resources :courses, only: %i(index show), shallow: true do
    concerns :passable, { controller: :courses, with_passages: true }
    resources :lessons, only: %i(index show) do
      concerns :passable, { controller: :lessons }
    end
  end

  #
  # Passages
  #
  resources :passages, only: %i(show), shallow: true do
    resources :solutions, controller: 'passage_solutions', only: :create
    member do
      patch :try_pass
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
    end
    resources :solutions, controller: 'passage_solutions', only: %i(index show) do
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
