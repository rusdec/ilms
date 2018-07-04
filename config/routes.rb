Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  resources :courses, only: [:index, :show]
  namespace :course_master do
    resources :courses
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
