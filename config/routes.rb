Rails.application.routes.draw do
  root to: "message#index"

  post "/post_message", to: "message#post_message"
  post "/post_comment", to: "comment#post_comment"
  delete "/delete_message", to: "message#delete_message"
  delete "/delete_comment", to: "comment#delete_comment"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
