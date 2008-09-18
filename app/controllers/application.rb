class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem
  include RoleRequirementSystem

  helper :all # include all helpers, all the time
  protect_from_forgery :secret => '8c4c66a250987cb59c7eb90053e840e4'
  filter_parameter_logging :password, :password_confirmation
  
  def pages_menu
    @menupages = Page.find(:all, :conditions => "parent_id IS NULL", :order => "position")
  end
  
end
