Rails.application.routes.draw do
  get '/register' => 'users#new'

  post '/lenders(.:format)' => 'lenders#create'
  get '/lenders/:id(.:format)' => 'lenders#show'

  post '/borrowers(.:format)' => 'borrowers#create'
  get '/borrowers/:id(.:format)' => 'borrowers#show'

  post '/lenders/lend' => 'lenders#lend_money'


	get '/login' => 'sessions#new'
	post '/login' => 'sessions#create'
	delete '/logout' => 'sessions#destroy' 
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
