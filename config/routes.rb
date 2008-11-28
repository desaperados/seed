ActionController::Routing::Routes.draw do |map|
  
  map.from_plugin APP_CONFIG[:app_name] + "_engine"
  
  #Restful Authentication
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  
  map.resource :session
  map.resources :users, :passwords, :roles, :images, :documents
  map.resources :comments, :collection => { :destroy_multiple => :delete},
                :member => { :approve => :put, :reject => :put }
  map.resources :pages do |page|
    page.resources :components, :name_prefix => nil
    page.resources :articles, :name_prefix => nil, :as => "content"
    page.resources :newsitems, :name_prefix => nil, :as => "latest", :collection => {:archive => :get}
    page.resources :posts, :name_prefix => nil, :as => "posts", :collection => {:archive => :get}
    page.resources :events, :name_prefix => nil, :as => "list"
  end
  
  # Search
  map.search 'search', :controller => "search", :action => "index"
  
  # Calendar Mapping
  map.browse 'pages/:page_id/browse/:month/:year', :controller => 'events', :action => 'index'
  
  # News Archive Mapping
  map.archive 'pages/:page_id/archive/:month/:year', :controller => 'newsitems', :action => 'archive'
  map.annual_archive 'pages/:page_id/archive/:year', :controller => 'newsitems', :action => 'archive'
  
  # Blog Archive Mapping
  map.blog_archive 'pages/:page_id/archived/:month/:year', :controller => 'posts', :action => 'archive'
  map.blog_annual_archive 'pages/:page_id/archived/:year', :controller => 'posts', :action => 'archive'

  map.home "", :controller => "articles", :page_id => "1"
  map.root :home
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
