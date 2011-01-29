class SessionWorkaround < ActiveRecord::Base
  has_many :image_uploads, :dependent => :destroy
  
  def self.translate_action(action)
    return "new"   if action == "new" or action == "create"
    return "edit"  if action == "edit" or action == "update" 
  end
end
