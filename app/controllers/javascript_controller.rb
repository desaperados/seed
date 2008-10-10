class JavascriptController < ApplicationController
  
  layout nil
  
  # Used by Pages new and edit actions for menu_type
  # dependent select dropdown
  def replace_page_menu_type
    if params[:actiontype] == "edit"
      @page = Page.find(params[:id]) 
    else
      @page = Page.new
    end
    @page.menu_type = params[:menu_type]
    render :update do |page|
      page.replace "page_parent_id", :partial => "pages/menu_type", :locals => {:action => params[:actiontype]}
    end
  end
  
  # Used by Roles, Add User to Role.
  def list_users
    @users = User.find(:all)
    @roleid = params[:role]
  end
  
  #TODO Make this method more efficient
  def assign_role
    user = User.find(params[:id])
    role = Role.find(params[:role])
    begin
      exists = user.roles.find(role.id)
    rescue
      exists = false
    end
    user.roles << role unless exists
    render :update do |page|
      if exists
      else
        page.insert_html :bottom, "#{role.name}_table", :partial => "roles/userrow", :object => user, :locals => {:roleid => role.id}
      end
    end
  end
  
  def remove_role
    user = User.find(params[:id])
    role = Role.find(params[:role])
    # Prevent an admin from removing themselves
    user.roles.delete(role) unless user.id = current_user.id
    render :update do |page|
      page.remove "user_#{user.id}_role_#{role.id}" 
    end
  end
  
  def update_item_order
    elements = params[:sortableitems] || params[:sortablecomponents]
    elements.each_with_index do |id, position|
      params[:class_name].constantize.update(id, :position => position)
    end
    render(:nothing => true)
  end
  
  def update_page_order
    pages = params[:menupages] || params[:menupages2]
    pages.each_pair do |position, value|
      if value.is_a?(Hash)
        value.each_pair do |pos, v|
          if v.is_a?(String)
            Page.update(v, :position => position)
          else
            Page.update(v.values[0], :position => pos)
          end
        end
      else
        Page.update(value.values, :position => position)
      end
    end
    render(:nothing => true)
  end
  
end

