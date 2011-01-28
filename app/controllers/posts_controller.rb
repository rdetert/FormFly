class PostsController < ApplicationController  
  before_filter :get_image_uploads, :only => [:new, :create, :ajax_photo_upload, :ajax_photo_destroy]
  
  @@return_early = Proc.new do 
    render :json => {:status => 0, :message => "Error"}.to_json
    return false
  end
  
  def index
    @posts = Post.all
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  # def member_ajax_photo_destroy
  #   @post = Post.find(params[:id])
  #   @post.images.where(:slot => params[:slot]).all.each do |image| 
  #     @status = image.destroy
  #   end
  #   if @status.nil?
  #     render :json => {:status => 0, :message => "Could Not Destroy Image!"}.to_json
  #   else
  #     render :json => {:status => 1, :message => "Successfully Destroyed Image!"}.to_json
  #   end
  # end
  # 
  # def member_ajax_photo_upload
  #   @post = Post.find(params[:id])
  #   # To make things easier in Uploadify, I hijacked the `folder` parameter
  #   slot = params[:folder].match(/pic(\d)/) unless params[:folder].nil?
  #   slot = slot[1] unless slot.nil?
  #   @@return_early.call if slot.nil?
  #   slot = "pic#{slot}"
  #   
  #   @current_images = @post.images.where(:slot => slot).all
  #   @upload = Image.new(:slot => slot, :data => params[:Filedata])
  #   if not @post.images << @upload
  #     render :json => {:status => 0, :message => "Error Uploading Image!"}.to_json
  #   else
  #     @current_images.each{|image| image.destroy}
  #     render :json => {:status => 1, :img => my_thumb(@upload, 118, 118).url }.to_json
  #   end
  # end
  
  def ajax_photo_destroy
    @image_uploads.images.where(:slot => params[:slot]).all.each do |image| 
      @status = image.destroy
    end
    if @status.nil?
      render :json => {:status => 0, :message => "Could Not Destroy Image!"}.to_json
    else
      render :json => {:status => 1, :message => "Successfully Destroyed Image!"}.to_json
    end
  end
  
  def ajax_photo_upload
    # To make things easier in Uploadify, I hijacked the `folder` parameter
    slot = params[:folder].match(/pic(\d)/) unless params[:folder].nil?
    slot = slot[1] unless slot.nil?
    @@return_early.call if slot.nil?
    slot = "pic#{slot}"
    
    @current_images = @image_uploads.images.where(:slot => slot).all
    @upload = Image.new(:slot => slot, :data => params[:Filedata])
    # debugger
    if not @image_uploads.images << @upload
      render :json => {:status => 0, :message => "Error Uploading Image!"}.to_json
    else
      @current_images.each{|image| image.destroy}
      render :json => {:status => 1, :img => my_thumb(@upload, 118, 118).url }.to_json
    end
  end
  
  def new
    @post = Post.new
  end
  
  def create
    # debugger
    @post = Post.new(params[:post])
    @post.assetable = @image_uploads.assetable
    # debugger
    Post.transaction do
      if @post.save
        # debugger
        @image_uploads.assetable = nil
        @image_uploads.destroy
        session[:image_upload_id] = nil
        redirect_to(posts_path, :notice => 'Post was successfully created.')
      else
        # debugger
        render :new
      end
    end
  end
  
  def edit
    @post = Post.find(params[:id])
    @post.images.each{|image| @post.image_upload.images << image.clone }
    debugger
    x = 0
  end
  
  def update
    @post = Post.find(params[:id])
    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
private

  def get_image_uploads
    if session[:image_upload_id].nil?
      @image_uploads = ImageUpload.create!
      debugger
      a=0
    else
      @image_uploads = ImageUpload.find_or_create_by_id(session[:image_upload_id])
      debugger
      b=0
    end
    session[:image_upload_id] = @image_uploads.id
    debugger
    x=0
  end
  
end
