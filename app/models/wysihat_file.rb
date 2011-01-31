class WysihatFile < ActiveRecord::Base
  has_attached_file :file
  
  belongs_to :user
end