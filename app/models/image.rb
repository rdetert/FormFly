class Image < Asset
  set_table_name "images"
  image_accessor :data
  validates_size_of :data, :maximum =>  500.kilobytes
  validates_property :mime_type, :of => :data, :in => %w(image/jpeg image/jpg image/png image/gif)
  
  def destroy
    hack = self.data
    if not self.delete_from_disk
      self.data = nil
      hack.instance_variable_set("@previous_uid", nil)
    end
    super
  end
  
end
