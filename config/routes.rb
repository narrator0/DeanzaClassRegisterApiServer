Rails.application.routes.draw do
  defaults format: :json do
    root 'pages#index'

    # Course API
    get 'courses' => 'courses#index'
    get 'courses/:id' => 'courses#show'

    # Auth
    devise_for :users, only: [:sessions], controllers: {
      sessions: 'users/sessions'
    }

    devise_scope :user do
      post 'signin' => 'users/sessions#create'
    end

    post 'signup' => 'users#create'

    # User API
    patch 'users' => 'users#update'
    get   'user/subscriptions' => 'users#subscriptions'
    get   'user/notifications' => 'users#notifications'

    # Subscribe API
    post 'subscribe' => 'subscriptions#subscribe'

    # Notification API
    patch 'notification/:id/read' => 'notifications#read'
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
