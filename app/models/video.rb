class Video < ActiveRecord::Base
    ###################################
    # AR Plugins/gems
    ###################################
    #paperclip
    has_attached_file :thumbnail, :styles=>{:thumb=>"200x200>"}
    
    
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
    validates_inclusion_of :private, :in=>[true,false]
    validates_uniqueness_of :video_paper_id
    validates_length_of :description, :maximum=>500
    
    ###################################
    # Callbacks
    ###################################
    before_create :set_kaltura_metadata_fields
    after_create :update_kaltura_metadata
    
    # Public Methods
    def processed?
      check_video_status unless self.processed
      self.processed
    end
    
    def private?
      self.private
    end
    
    def public?
      !private?
    end
    
    # Protected Methods
    protected
    
    def set_kaltura_metadata_fields
      KalturaFu.set_video_description(self.entry_id,self.description)
      KalturaFu.set_category(self.entry_id,Rails.env)
      self.processed = false
      #the last statement can't be false, so we return true.  tru dat.
      true
    end
    
    def update_kaltura_metadata
      video_info = KalturaFu.get_video_info(self.entry_id)
      self.duration = video_info.duration  
      check_video_status
    end
    
    def check_video_status
      status = KalturaFu.check_video_status(self.entry_id)
      case status
        when KalturaFu::READY
          self.processed = true
      else
        self.processed = false
      end
      true
    end
end
