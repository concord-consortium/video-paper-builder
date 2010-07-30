class VideoPaper < ActiveRecord::Base
  
  ###################################
  # Associations
  ###################################
  belongs_to :user, :foreign_key=> "owner_id"
  
  
  ###################################
  # Validations
  ###################################
  validates_presence_of :title
  validates_presence_of :owner_id

end
