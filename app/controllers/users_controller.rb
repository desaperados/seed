class UsersController < ApplicationController  

  before_filter :login_required, :only => [:index, :show]
  require_role "admin", :only => [:index]
  before_filter :pages_menu, :except => [:activate]
  
  def index
    @users = User.find(:all)
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
 
  # Create behaviour allows for users to be created by an admin user
  # with activation via email or via self signup and activation
  def create
    if current_user.has_role? "admin"
      internal = true
    else
      logout_keeping_session!
    end
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      if internal
        redirect_to users_url
        flash[:notice] = "User created! An email has been sent to #{@user.email} for account activation."
      else
        redirect_back_or_default('/')
        flash[:notice] = "Thanks for signing up! We're sending you an email with your activation code."
      end
    else
      flash[:error]  = "We couldn't set up that account, sorry. Please try again."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing. Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = "Details successfully updated. Confirmation sent by email."
      redirect_to user_url(params[:id])
    else
      render :action => "show"
    end
  end
  
  def destroy
    user = User.find(params[:id])
    begin
      user.destroy
      flash[:notice] = "#{user.name} deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end
    redirect_to users_path
  end
  
end
