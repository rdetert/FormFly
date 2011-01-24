module PostsHelper
  def upload_image_path(klass)
    if klass.class == ImageUpload
      upload_photo_posts_path
    else
      member_upload_photo_posts_path(klass)
    end
  end
  def destroy_image_path(klass, slot="")
    if klass.class == ImageUpload
      destroy_photo_posts_path(slot)
    else
      member_destroy_photo_posts_path(klass, slot)
    end
  end
end
