class RolesController < ApplicationController
  
  before_filter :login_required
  require_role "admin"
  
  def new
    @role = Role.new
  end
  
  def edit
    @role = Role.find(params[:id])
  end
  
  def update
    @role = Role.find(params[:id])

    if @role.update_attributes(params[:role])
      flash[:notice] = 'Role was successfully updated'
      redirect_to users_path(:role => @role.id)
    else
      render :action => "edit" 
    end
  end
  
  def create
    @role = Role.new(params[:role])

    if @role.save
      flash[:notice] = 'Role was successfully created'
      redirect_to users_path(:role => @role.id)
    else
      render :action => "new" 
    end
  end
  
end
