Rails.application.routes.draw do
  defaults format: :json do

    # Course API
    get 'courses' => 'courses#index'

    # Auth
    post 'signup' => 'users#create'
    post 'signin' => 'tokens#create'

    # User API
    patch 'users' => 'users#update'

    # Subscribe API
    post 'subscribe' => 'subscribtions#subscribe'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
