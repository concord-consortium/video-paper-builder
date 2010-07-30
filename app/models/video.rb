class Video < ActiveRecord::Base
    
    ###################################
    # Associations
    ###################################
    belongs_to :video_paper
  
    ###################################
    # Validations
    ###################################
    validates_presence_of :description
    validates_presence_of :entry_id
    validates_uniqueness_of :video_paper_id
end
