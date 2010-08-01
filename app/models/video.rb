class Video < ActiveRecord::Base
    
    ###################################
    # Associations
    ###################################
    belongs_to :video_paper
    belongs_to :language
  
    ###################################
    # Validations
    ###################################
    validates_presence_of :description
    validates_presence_of :entry_id, :message=>"You need to upload a video."
    validates_presence_of :language_id
    validates_uniqueness_of :video_paper_id
    validates_length_of :description, :maximum=>500
end
