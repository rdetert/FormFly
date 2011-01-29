Formfly::Application.routes.draw do
  
  match '/media(/:dragonfly)', :to => Dragonfly[:images]
  
  match '/posts/ajax_photo_destroy/(:slot/:_action)' => "posts#ajax_photo_destroy", :as => :destroy_photo_posts
  resources   :posts do
    match 'ajax_photo_upload', :on => :collection, :as => :upload_photo
  end
  
  root  :to => 'posts#index'
  
end
