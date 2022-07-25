Rails.application.routes.draw do
  resources :word_nets do
    collection do
      post :search
      post :hypernym
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
