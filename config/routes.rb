ActionController::Routing::Routes.draw do |map|
  
  map.resource :session
  map.resources :images, :users
  map.resources :pages, :has_many => [:articles]

  map.home "", :controller => "articles", :page_id => "1"
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
