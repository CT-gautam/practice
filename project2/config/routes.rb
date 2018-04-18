Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'posts/index'
  get 'pages/about'
  root 'posts#index'
  get 'abouts' => 'pages#about'

  resources :posts do
  	resources :comments
	end
end
