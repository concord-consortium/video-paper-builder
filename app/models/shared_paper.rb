class SharedPaper < ActiveRecord::Base
  
  ###################################
  # Associations
  ###################################
  belongs_to :video_paper
  belongs_to :user
  
  ###################################
  # Validations
  ###################################
  validates_presence_of :user_id
  validates_presence_of :video_paper_id 
  
end
