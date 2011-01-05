class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  
  helper_method :my_thumb
  
  def my_thumb(image, w, h)
    image.data.process(:resize_and_crop, :width => w, :height=> h, :gravity => 'ne')
  end
end
