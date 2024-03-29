Chores::Application.routes.draw do
  resources :choretypes
  resources :contexts

 get '/about' => 'static_pages#about', as: :about_page
 get '/contact' => 'static_pages#contact', as: :contact_page

  resources :projects do
    collection do
      #get :manage - probably don't need
      get :someday
      get :show_archived
      # required for Sortable GUI server side actions
      post :rebuild
    end
  end
  put 'project/:id/archive' => "projects#archive", as: 'archive_project'
  
  resources :chores do
    collection do
      get :occurrences
      get :status_quo
      get :calendar
      get :show_archived
    end
  end
  put 'chore/:id/skip' => "chores#skip", as: 'skip_chore'
  put 'chore/:id/archive' => "chores#archive", as: 'archive_chore'
  
  resources :emails do
  collection do
      get :login
      get :login_callback
      get :show_messages
      delete :delete_thread
      get :convert_to_project
    end
  end

  devise_for :users
  resources :users

  devise_scope :user do
    get "/login" => "devise/sessions#new"
    post "/login" => "devise/sessions#create"
    delete "/logout" => "devise/sessions#destroy"
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  root :to => 'static_pages#home'


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
