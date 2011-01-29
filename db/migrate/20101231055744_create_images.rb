class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.belongs_to  :assetable
      t.string      :slot
      t.string      :data_uid
      t.boolean     :delete_from_disk, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
