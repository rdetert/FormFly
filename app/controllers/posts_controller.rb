class PostsController < ApplicationController
  protect_from_forgery :except => [:ajax_photo_upload, :ajax_photo_destroy]
  
  before_filter :get_image_uploads
  
  def index
    @posts = Post.all
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  def ajax_photo_destroy
    if @image_uploads.nil?
      render :text => ""
      return false 
    end
    
    @image_uploads.images.where(:slot => params[:slot]).all.each{|image| image.destroy}

    respond_to do |format|
      format.html {render :layout => false}
      format.js {render :layout => false}
    end
  end
  
  def uploadify_photo_upolad
    debugger
  end
  
  def ajax_photo_upload
    if @image_uploads.nil?
      render :text => ""
      return false 
    end
    
    # slot must correspond to the file field form name of pic1, pic2, or pic3
    slot = nil
    (1..3).each do |i|      
      slot = "pic#{i}" unless params[:"pic#{i}"].nil?
    end
    
    if slot.nil?
      render :text => ""
      return false
    end
    
    @image_uploads.images.where(:slot => slot).all.each{|image| image.destroy}
    @upload = Image.new(:slot => slot, :data => params[slot.to_sym])
    
    if not @image_uploads.images << @upload
      @errorMessage = "There was a problem uploading your image."
    end
    
    respond_to do |format|
      format.html {render :layout => false}
      format.js {render :layout => false}
    end
  end
  
  def new
    @post = Post.new
    if @image_uploads.nil?
      @image_uploads = ImageUpload.create!
      session[:image_upload] = @image_uploads.id
    end
  end
  
  def create
    @post = Post.new(params[:post])
    @post.assetable = @image_uploads.assetable
    Post.transaction do
      if @post.save
        @image_uploads.assetable = nil
        # @image_upload.save
        @image_uploads.destroy
        session[:image_upload] = nil
        redirect_to(posts_path, :notice => 'Post was successfully created.')
      else
        render :new
      end
    end
  end
  
private

  def get_image_uploads
    @image_uploads = ImageUpload.find(session[:image_upload]) rescue nil
  end
  
end
