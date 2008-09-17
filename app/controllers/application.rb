class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem
   
  helper :all # include all helpers, all the time

  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8c4c66a250987cb59c7eb90053e840e4'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def pages_menu
    @menupages = Page.find(:all, :conditions => "parent_id IS NULL", :order => "position")
  end
  
end
