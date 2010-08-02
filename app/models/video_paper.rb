class VideoPaper < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :owner_id
  
  belongs_to :user, :foreign_key=> "owner_id"
  has_many :sections
  
end
