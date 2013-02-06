class WysihatFile < ActiveRecord::Base
  has_attached_file :file,
    :path => ':rails_root/public/system/:attachment/:id/:style/:filename',
    :url => '/system/:attachment/:id/:style/:filename'
  
  belongs_to :user
end