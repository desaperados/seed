class ImagesController < ApplicationController
  
  layout "application"
  before_filter :login_required
  before_filter :pages_menu, :except => [:create, :destroy]

  def new
    @image = Image.new
    @images = Image.originals
  end

  def create
    @image = Image.new(params[:image])
    
    if @image.save
      flash[:notice] = 'Image was successfully uploaded'
      redirect_to new_image_path
    else
      @images = Image.originals
      pages_menu
      render :action => "new"
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    
    redirect_to new_image_path 
  end
end
