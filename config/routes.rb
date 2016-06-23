Rails.application.routes.draw do
  resources :votes
  resources :likes, only: [:index]
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy] do
    delete :destroy, on: :collection
  end

  resources :questions do
    resources :likes, only: [:create, :destroy]
    # This will define a route that will be '/questions/search'
    # It will pont to the 'questions#search'
    # on: :collection makes the route not have an id on it
    get :search, on: :collection

    # This will generate a route '/questions/:id/flag'
    # It will point to 'questions#flag'
    # on: :member makes the route include an ':id' in it similar to 'edit'
    post :flag, on: :member

    post :mark_done

    # This will make all the answers routes nested within 'question'.
    # This means all answers routes will be prepended with
    # '/questions/:question_id'
    resources :answers, only: [:create, :destroy]
  end

    # get    "/questions/new"      => "questions#new", as: :new_question
    # get    "/questions/:id"      => "questions#show", as: :question
    # post   "/questions"          => "questions#create", as: :questions
    # get    "/questions"          => "questions#index"
    # get    "/questions/:id/edit" => "questions#edit", as: :edit_question
    # patch  "/questions/:id"      =>   "questions#update"
    # delete "/questions/:id"     => "questions#destroy"

  # This is a route that specifies if we get a request that has a GET HTTP verb with '/about' url, use the HomeController with about action
  get "/about" => "home#about"
  root "home#index"
  get "/greet/:name" => "home#greet", as: :greet

  get "/cowsay" => "cowsay#index"
  post "/cowsay" => "cowsay#create", as: :cowsay_submit

  get "/temp_converter" => "temp#index"
  post "/temp_converter" => "temp#create"

  get "/bill_splitter" => "bill_splitter#index"
  post "/bill_splitter" => "bill_splitter#split"

  get "/admin/questions" => "questions#index"

  get "/name_picker" => "name_picker#index"
  post "/name_picker" => "name_picker#pick"

  namespace :admin do
    resources :questions
  end
end
