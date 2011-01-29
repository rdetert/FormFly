class ImageUpload < ActiveRecord::Base
  belongs_to  :assetable, :dependent => :destroy, :autosave => true
  delegate    :images, :to => :assetable
  belongs_to  :session_workaround
  
  after_initialize  { build_assetable if assetable.nil? }

end
