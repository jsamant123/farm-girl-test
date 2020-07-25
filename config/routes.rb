Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :orders, only: %i[index new create show] do
    post :mark_fulfilled
  end
  root to: 'orders#index'
end
