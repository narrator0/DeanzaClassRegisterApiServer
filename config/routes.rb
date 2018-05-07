Rails.application.routes.draw do
  defaults format: :json do
    get 'courses' => 'courses#index'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
