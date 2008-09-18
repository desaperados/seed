class RolesController < ApplicationController
  
  before_filter :login_required
  require_role "admin"
  before_filter :pages_menu, :except => [:create, :update, :destroy]
  
  def index
    @roles = Role.find(:all)
  end
  
  def new
    @role = Role.new
  end
  
  def edit
    @role = Role.find(params[:id])
  end
  
  def create
    @role = Role.new(params[:role])

    if @role.save
      flash[:notice] = 'Role was successfully created'
      redirect_to roles_path 
    else
      pages_menu
      render :action => "new" 
    end
  end
  
end
