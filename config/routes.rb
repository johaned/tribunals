Tribunals::Application.routes.draw do
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
end
