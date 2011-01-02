class Assetable < ActiveRecord::Base
  set_table_name "assetable"
  has_many :images, :dependent => :destroy
end
