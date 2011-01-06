Formfly::Application.routes.draw do
  
  # match '/media(/:dragonfly)', :to => Dragonfly[:images]
  
  post '/posts/ajax_photo_destroy/(:slot)' => "posts#ajax_photo_destroy", :as => :destroy_photo_posts
  resources   :posts do
    post 'ajax_photo_upload', :on => :collection, :as => :upload_photo
  end
  
  root  :to => 'posts#index'
  
end
