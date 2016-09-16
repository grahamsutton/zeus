Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :customers do
    resources :accounts do
        resources :journal_entries
    end
  end
end
