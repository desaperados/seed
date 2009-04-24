class JavascriptController < ApplicationController
  
  layout nil
  cache_sweeper :page_sweeper, :only => [:update_page_order]
  auto_complete_for :user, :name
  
  # Page Access Control 
  def update_page_viewable
    page = Page.find(params[:id])
    page.viewable_by = params[:role]
    page.save
    render :nothing => true
  end
  
  def update_page_editable
    page = Page.find(params[:id])
    page.editable_by = params[:role]
    page.save
    render :nothing => true
  end
  
  # Used by select Role filter on Users index
  def list_users_by_role
    @role = Role.find(params[:role]) unless params[:role].blank?
    @users = @role ? @role.users : User.paginate(:page => params[:page], :per_page => 40)
    render :update do |page|
      if @role
        page.replace_html "role-info", :partial => "roles/role"
        page.replace_html "edit-role-link", link_to("Edit", edit_role_path(@role))
      else
        page.replace_html "role-info", "<strong id='role-name'>All Users</strong>"
      end
      page.replace_html "user-list", :partial => "users/user", :collection => @users
      if !@role
        page.insert_html :bottom, "user-list", "<tr><td colspan='7'>#{will_paginate @users}</td></tr>"
      end
    end
  end
  
  #TODO Make this method more efficient
  def assign_role
    role = Role.find(params[:id])
    
    begin
      user = User.find_by_name(params[:user][:name])
    rescue
      raise "User not found"
      user = false
    end
    
    if user
      begin
        exists = user.roles.find(role.id) 
      rescue
        exists = false
      end
      user.roles << role unless exists
    end
    
    render :update do |page|
      if exists
        page.replace_html "user-grp-error", "<div>User was already added to this group</div>"
      elsif !user
        page.replace_html "user-grp-error", "<div>User not found</div>"
      else
        @role = role.id
        page.replace_html "user-grp-error", ""
        page.insert_html :top, "user-list", :partial => "users/user", :object => user
      end
    end
  end
  
  def remove_role
    user = User.find(params[:id])
    role = Role.find(params[:role])
    # Prevent an admin from removing themselves
    user.roles.delete(role) unless (user.id == current_user.id && role.name == "admin")
    render :update do |page|
      page.remove "user_#{user.id}" 
    end
  end
  
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
  
  def update_item_order
    elements = params[:sortableitems] || params[:sortablecomponents]
    elements.each_with_index do |id, position|
      params[:class_name].constantize.update(id, :position => position)
    end
    render(:nothing => true)
  end
  
  def update_page_order
    params.each_key {|key|
      if key.include?('parent')
        p_id = key[/(\d)/]
        p_id = nil if p_id == "0" || p_id == "00"
        params[key].each_with_index do |id, position|
         Page.update(id, :position => position, :parent_id => p_id)
        end
        render :nothing => true
      end
    }
  end
  
end

