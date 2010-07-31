class Language < ActiveRecord::Base
  
  ###################################
  # Associations
  ###################################
  has_many :videos
  
  ###################################
  # Validations
  ###################################
  validates_uniqueness_of :code
  validates_uniqueness_of :name
end
