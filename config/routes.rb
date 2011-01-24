Formfly::Application.routes.draw do
  
  match '/media(/:dragonfly)', :to => Dragonfly[:images]
  
  post '/posts/:id/ajax_photo_upload/(:slot)' => "posts#member_ajax_photo_upload", :as => :member_upload_photo_posts
  
  post '/posts/:id/ajax_photo_destroy/(:slot)' => "posts#member_ajax_photo_destroy", :as => :member_destroy_photo_posts
  post '/posts/ajax_photo_destroy/(:slot)' => "posts#ajax_photo_destroy", :as => :destroy_photo_posts
  resources   :posts do
    post 'ajax_photo_upload', :on => :collection, :as => :upload_photo
  end
  
  root  :to => 'posts#index'
  
end
