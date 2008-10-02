ActionController::Routing::Routes.draw do |map|
  
  #Restful Authentication
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  
  map.resource :session
  map.resources :users, :passwords, :roles, :images, :comments
  map.resources :pages do |page|
    page.resources :components, :name_prefix => nil
    page.resources :articles, :name_prefix => nil
    page.resources :newsitems, :name_prefix => nil, :as => "news"
    page.resources :posts, :name_prefix => nil, :as => "blog"
  end
  
  # News Archive Mapping
  map.archive 'pages/:page_id/news/archive/:month/:year', :controller => 'newsitems', :action => 'index'
  map.annual_archive 'pages/:page_id/news/archive/:year', :controller => 'newsitems', :action => 'index'
  
  # Blog Archive Mapping
  map.blog_archive 'pages/:page_id/blog/archive/:month/:year', :controller => 'posts', :action => 'index'
  map.blog_annual_archive 'pages/:page_id/blog/archive/:year', :controller => 'posts', :action => 'index'

  map.home "", :controller => "articles", :page_id => "1"
  map.root :home
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
