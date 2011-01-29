class CreateSessionWorkarounds < ActiveRecord::Migration
  def self.up
    create_table :session_workarounds do |t|
      t.string  :session_id
      t.string  :action
      t.timestamps
    end
    add_index :session_workarounds, [:session_id, :action]
  end
  
  def self.down
    drop_table :session_workarounds
  end
end
