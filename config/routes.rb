Tribunals::Application.routes.draw do
  get '/utiac/decisions', to: 'decisions#index', as: :root

  scope '/utiac' do
    resources :decisions
    get '/' => redirect('/utiac/decisions')
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
