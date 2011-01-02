class CreateAssetable < ActiveRecord::Migration
  def self.up
    create_table :assetable do |t|
    end
  end

  def self.down
    drop_table :assetable
  end
end
