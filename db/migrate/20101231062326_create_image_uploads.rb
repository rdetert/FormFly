class CreateImageUploads < ActiveRecord::Migration
  def self.up
    create_table :image_uploads do |t|
      t.belongs_to  :post
      t.belongs_to  :assetable
      t.timestamps
    end
  end

  def self.down
    drop_table :image_uploads
  end
end
