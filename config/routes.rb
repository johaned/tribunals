Tribunals::Application.routes.draw do
  get '/utiac/decisions', to: 'decisions#index', as: :root
  get '/aac/decisions', to: 'aac_decisions#index'

  scope '/utiac' do
    resources :decisions
    get '/' => redirect('/utiac/decisions')
  end

  scope '/aac' do
    resources :aac_decisions
  end

  namespace :admin do
    resources :decisions
    resource :authentication do
      get :logout
    end
  end
  get '/' => redirect('/utiac/decisions')

  resource :feedback
end
