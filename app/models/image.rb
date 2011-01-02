class Image < Asset
  set_table_name "images"
  image_accessor :data
  validates_size_of :data, :maximum =>  500.kilobytes
end
