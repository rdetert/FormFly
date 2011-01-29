class PostsController < ApplicationController 
  before_filter :translate_action, :except => [:index, :show]
  before_filter :get_image_uploads, :except => [:index, :show]
  
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
    @post = Post.new(params[:post])
    @post.assetable = @image_uploads.assetable
    Post.transaction do
      if @post.save
        @image_uploads.assetable = nil
        @image_uploads.save                       # Is this really necessary?
        @session_workaround.destroy
        redirect_to(posts_path, :notice => 'Post was successfully created.')
      else
        render :new
      end
    end
  end
  
  def edit
    @post = Post.find(params[:id])
    @image_uploads.images.each{ |image| image.destroy }
    @post.images.each do |image|
      cloned_image = image.clone
      cloned_image.delete_from_disk = false
      @image_uploads.images << cloned_image
    end
  end
  
  def update
    @post = Post.find(params[:id])
    Post.transaction do
      old_assetable = @post.assetable
      @post.assetable = @image_uploads.assetable
      respond_to do |format|
        if @post.update_attributes(params[:post])
          @post.images.each{|image| image.delete_from_disk = true }
          old_assetable.destroy
          @image_uploads.assetable = nil
          @image_uploads.save                     # Is this really necessary?
          @session_workaround.destroy
          format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
        else
          format.html { render :action => "edit" }
        end
      end
    end
  end
  
private

  def translate_action
    @_action = params[:_action] || SessionWorkaround.translate_action(params[:action])
  end

  def get_image_uploads
    # => Have to implement this instead of doing something like session[:image_upload_id]
    # => because 10% of the time the session variables would vanish????? :-/
    @session_workaround = SessionWorkaround.find_or_create_by_session_id_and_action(session[:session_id], @_action)
    if @session_workaround.image_uploads.empty?
      @session_workaround.image_uploads << ImageUpload.create!
    end
    @image_uploads = @session_workaround.image_uploads.first
  end
  
end
