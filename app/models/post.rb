class Post < ActiveRecord::Base
  belongs_to  :assetable, :dependent => :destroy
  delegate    :images, :to => :assetable
  
  after_initialize  { build_assetable if assetable.nil? }
  
  validates :title, :presence => true
  validates :body, :presence => true
  validates :images, :collection_size => { :min_size => 1, :max_size => 3 }
  
end
