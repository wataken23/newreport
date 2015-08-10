Rails.application.routes.draw do
#  resources :updates

#  resources :comments

  resources :tags

  resources :repbodies, :only=> %w[show index opinion destroy]

  resources :roles

  resources :users do
    resources :fileupload, :only => %w[index]
    resources :repbodies do #, :except => %w[new create destroy]
      resources :comments do
        resources :usercomments
      end
    end
  end
  resources :users#, :only => %w[indexyear] #, :except => %w[new create destroy update edit]

  resources :sessions 
  get "login" => "sessions#new", :as => "login" 
  get "logout" => "sessions#destroy", :as => "logout" 
  get "userapplicate" => "users#newext", :as => "userapplicate" 
  post "createext" => "users#createext", :as => "createext" , :via => "get"
  post "indexyear" => "users#indexyear", :as => "indexyear" , :via => "get"
  post "upload_process" => "fileupload#upload_process", :as => "upload_process" , :via => "get"
  post "repbodies" => "repbodies#index",  :via => "get"
  post "indexyeartag" => "repbodies#indexyeartag", :as => "indexyeartag", :via => "get"
#below match
  match '/acception/:id' => 'users#acception', :as => "acception", :via => "get"
  match '/mypage/:id' => 'users#mypage', :as => "mypage", :via => "get"
  match '/chpass/:id' => 'users#chpass', :as => "chpass", :via => "get"
  match '/userreportshow/:id' => 'users#userreportshow', :as => "userreportshow", :via => "get"
  match '/opinion/' => 'repbodies#opinion', :as => "opinion", :via => "get"
  match '/fileupload/' =>  'fileupload#upload', :via => "get"
  match '/years/' =>  'years#index', :via => [:get, :post]
  match '/avatar/:id' =>  'users#avatar',  :as => "avatar", :via => "get"
  match 'indexyear' => 'users#indexyear',  :via => "get"
  match 'indexyeartag' => 'repbodies#indexyeartag', :via => "get"


#  get '/mypage/:id' => 'users#mypage', :as => "mypage", :via => "get"
#  get '/chpass/:id' => 'users#chpass', :as => "chpass"
#  get '/userreportshow/:id' => 'users#userreportshow', :as => "userreportshow", :via => "get"
#  get '/opinion/' => 'repbodies#opinion', :as => "opinion"
#  get '/fileupload/' =>  'fileupload#upload'
#  get '/years/' =>  'years#index'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  match ':controller(/:action(/:id))(.:format)', :via => "get"
  root :to => 'showindex#index'
end
