class PostsController < ApplicationController  
  before_filter :get_image_uploads
   
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
     if session[:image_upload][params[:slot]].nil?
       render :json => {:status => 0, :message => "Error Destroying Image!"}.to_json
       return false
     end
     Dragonfly[:images].destroy(session[:image_upload][params[:slot]]) #TODO catch error
     render :json => {:status => 1, :message => "Successfully Destroyed Image!"}.to_json
   end
   
   def ajax_photo_upload    
     # To make things easier in Uploadify, I hijacked the `folder` parameter
     slot = params[:folder].match(/pic(\d)/) unless params[:folder].nil?
     slot = slot[1] unless slot.nil?
     @@return_early.call if slot.nil?
     slot = "pic#{slot}"
 
     @current_image = session[:image_upload][:"#{slot}"]
     session[:image_upload][:"#{slot}"] = Dragonfly[:images].store(params[:Filedata])  # TODO catch error
     Dragonfly[:images].destroy(@current_image) unless @current_image.nil?

     render :json => {:status => 1, :img => my_thumb(Dragonfly[:images].fetch(session[:image_upload][:"#{slot}"]), 118, 118).url }.to_json
   end
   
   def new
     @post = Post.new
     session[:image_upload].each do |key, value|
       @post.images << Image.new(:slot => key, :data_uid => value)
     end
   end
   
   def create
     @post = Post.new(params[:post])
     Post.transaction do
       session[:image_upload].each do |key, value|
         img = Image.create!(:slot => key, :data_uid => value)
         @post << img
       end
       if @post.save
         session[:image_upload] = nil
         redirect_to(posts_path, :notice => 'Post was successfully created.')
       else
         render :new
       end
     end
   end
 
 
 private
 
   def get_image_uploads
     debugger
     session[:x] ||= 0
     session[:x] += 1
     session[:image_upload] ||= {}
   end
  
end
