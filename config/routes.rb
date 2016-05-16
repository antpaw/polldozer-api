Rails.application.routes.draw do
  resources :polls, only: [:show, :new]

  namespace :api do
    namespace :v1 do
      resources :polls do
        member do
          put 'vote'
          patch 'vote'
          post 'vote'
        end
      end
    end
  end
end
