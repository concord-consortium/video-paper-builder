class Video < ActiveRecord::Base
    # Constants
    COMPLEX_SECONDS_PATTERN = /^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/
    SIMPLE_SECONDS_PATTERN = /(^-?\d\d*$)/
  
    ###################################
    # AR Plugins/gems
    ###################################
    #paperclip
    has_attached_file :thumbnail, :styles=>{:thumb=>"150x150>"}
    
    
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
    validates_format_of :thumbnail_time, :with=>SIMPLE_SECONDS_PATTERN,:allow_nil=>true,:allow_blank=>true
    
    ###################################
    # Callbacks
    ###################################
    before_validation :convert_complex_pattern_to_simple_pattern
    before_create :set_kaltura_metadata_fields
    after_create :update_kaltura_metadata

    ##################################
    # instance methods
    ##################################
    
    # Public Methods
    def processed?
      check_video_status unless self.processed == true
      return self.processed
    end
    
    def private?
      self.private
    end
    
    def public?
      !private?
    end
    
    # Protected Methods
    protected
    
    def convert_complex_pattern_to_simple_pattern
      unless self.thumbnail_time.nil? || self.thumbnail_time.blank?
        if self.thumbnail_time.to_s.match(COMPLEX_SECONDS_PATTERN)
          seconds = self.thumbnail_time
  
          parsed_seconds_array = seconds.split(":")
          self.thumbnail_time = (parsed_seconds_array.at(0).to_i * 3600) + (parsed_seconds_array.at(1).to_i * 60) + parsed_seconds_array.at(2).to_i
        end
      end
    end
    
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
      save!
      return true
    end
    
    def check_video_status
      status = KalturaFu.check_video_status(self.entry_id)
      case status
        when KalturaFu::READY
          self.processed = true
      else
        self.processed = false
      end
      save!
      return self.processed
    end
end
