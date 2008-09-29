class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem
  include RoleRequirementSystem
  
  before_filter :get_controller

  helper :all # include all helpers, all the time
  protect_from_forgery :secret => '8c4c66a250987cb59c7eb90053e840e4'
  filter_parameter_logging :password, :password_confirmation
  
  def pages_menu
    pages = Page.find(:all, :conditions => ["parent_id IS NULL"], :order => "position")
    grouped_pages = pages.group_by { |p| p[:menu_type] }
    @primary_pages = grouped_pages["primary"]
    @secondary_pages = grouped_pages["secondary"]
  end
  
  def get_controller
    @controller_path = self.class.controller_path
  end
  
end
