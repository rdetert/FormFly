class ImageUpload < ActiveRecord::Base
  belongs_to :assetable, :dependent => :destroy
  delegate  :images, :to => :assetable
  
  after_initialize  { build_assetable if assetable.nil? }

end
