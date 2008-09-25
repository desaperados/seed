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
  map.resources :users, :passwords, :roles
  map.resources :images, :collection => {:ajax_create => :post, :ajax_new => :get}
  map.resources :pages do |page|
    page.resources :articles, :name_prefix => nil
    page.resources :newsitems, :name_prefix => nil, :as => "news"
    page.resources :posts, :name_prefix => nil
  end

  map.home "", :controller => "articles", :page_id => "1"
  map.root :home
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
