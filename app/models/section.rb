class Section < ActiveRecord::Base
  ###################################
  # Associations
  ###################################
  belongs_to :video_paper
  
  ###################################
  # Validations
  ###################################
  validates_presence_of :video_paper
  validates_presence_of :title
end
