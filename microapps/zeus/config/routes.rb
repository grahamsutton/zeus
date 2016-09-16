Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/begin'  => 'negotiations#begin',  :as => :begin_negotiation
  get '/commit' => 'negotiations#commit', :as => :commit_negotiation

  get  '/request' => 'requests#get',  :as => :get_request
  post '/request' => 'requests#post', :as => :post_request
end
