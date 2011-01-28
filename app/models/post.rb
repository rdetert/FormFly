class Post < ActiveRecord::Base
  belongs_to  :assetable, :dependent => :destroy
  delegate    :images, :to => :assetable
  has_one     :image_upload
  
  after_initialize  { build_assetable if assetable.nil? }
  # after_initialize  { build_image_upload if image_upload.nil? }
  
  validates :title, :presence => true
  validates :body, :presence => true
  validates :images, :collection_size => { :min_size => 1, :max_size => 3 }
  
end
