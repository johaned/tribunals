Tribunals::Application.routes.draw do
  resources :decisions
  namespace :admin do
    resources :decisions
    resource :authentication do
      get :logout
    end
  end
  root :to => 'decisions#index'
end
