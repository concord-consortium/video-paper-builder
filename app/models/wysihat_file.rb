class WysihatFile < ActiveRecord::Base
  has_attached_file :file,
    :path => ':rails_root/public/system/:attachment/:id/:style/:filename',
    :url => '/system/:attachment/:id/:style/:filename'

  belongs_to :user

  validates_attachment :file, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
end