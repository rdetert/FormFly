class Image < Asset
  set_table_name "images"
  image_accessor :data
  validates_size_of :data, :maximum =>  500.kilobytes
  validates_property :mime_type, :of => :data, :in => %w(image/jpeg image/jpg image/png image/gif)
  
  before_destroy  :testing
  def testing
    self.data = nil unless self.delete_from_disk
  end
  
  # Not sure why, but this doesn't work
  # def destroy
  #   self.data = nil unless self.delete_from_disk
  #   super
  # end
  
end
