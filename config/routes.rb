Rails.application.routes.draw do
  devise_for :users

  concern :home do
    get '/', to: 'home#index'
  end

  concern :passable do |options|
    member do
      post :learn, action: :learn!
    end
    if options[:with_passages]
      collection do
        get 'passages/all', action: :passages
      end
    end
  end

  concern :badgable do
    resources :badges, only: %i(create new)
  end

  #
  # All users
  #
  root to: 'home#index'
  resources :users, only: %i(show update)
  resources :courses, only: %i(index show), shallow: true do
    concerns :passable, { with_passages: true }
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
