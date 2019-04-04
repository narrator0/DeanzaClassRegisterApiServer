Rails.application.routes.draw do
  root 'pages#index'

  # devise also has this path, so make it before devise
  patch 'users' => 'users#update', defaults: { format: 'json' }

  # Auth
  devise_for :users, only: [:registrations, :sessions, :passwords], controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
  }

  defaults format: :json do
    # Course API
    get 'courses' => 'courses#index'
    get 'courses/quarters' => 'courses#quarters'
    get 'courses/:id' => 'courses#show'

    # User API
    get 'user/subscriptions' => 'users#subscriptions'
    get 'user/notifications' => 'users#notifications'
    get 'user/information'   => 'users#information'

    devise_scope :user do
      post 'signin' => 'users/sessions#create'
      post 'signup' => 'users/registrations#create'
    end

    # Subscribe API
    post 'subscribe' => 'subscriptions#subscribe'

    # Notification API
    patch 'notification/:id/read' => 'notifications#read'
    patch 'notification/readAll' => 'notifications#read_all'
  end

  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
