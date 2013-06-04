Tribunals::Application.routes.draw do
  resources :decisions
  namespace :admin do
    resources :decisions
  end
  root :to => 'decisions#index'
end
