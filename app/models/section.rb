class Section < ActiveRecord::Base
  # Constants
  COMPLEX_SECONDS_PATTERN = /^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/
  SIMPLE_SECONDS_PATTERN = /^\d*$/
  
  ###################################
  # Associations
  ###################################
  belongs_to :video_paper
  
  ###################################
  # Validations
  ###################################
  validates_presence_of :video_paper_id
  validates_presence_of :title
  validates_format_of :video_start_time, :with=>SIMPLE_SECONDS_PATTERN,:allow_nil=>true,:allow_blank=>true
  validates_format_of :video_stop_time, :with=>SIMPLE_SECONDS_PATTERN,:allow_nil=>true,:allow_blank=>true
  validate :start_time_is_less_than_stop_time 
  
  ###################################
  # Callbacks
  ###################################
  before_validation :convert_complex_pattern_for_video_start_time
  before_validation :convert_complex_pattern_for_video_stop_time
  before_save :reset_start_and_stop_times  
    
  ##################################
  # instance methods
  ##################################
  
  def to_timestamp(time_in_seconds)
    time_to_format = time_in_seconds.to_i
    hours  = (time_to_format / 3600).to_i
    minutes = ((time_to_format % 3600) / 60).to_i
    seconds = (time_to_format % 60).to_i
    
    "%02i:%02i:%02i" % [hours.to_s,minutes.to_s,seconds.to_s]
  end
  
  ##
  # I'll admit, this is probably overkill.  This is a dynamic method for 
  # converting the hh:mm:ss format into a seconds format for the start and stop times. 
  #
  # When the larger method name isn't found, it hits method missing and then does the appropriate
  # method.
  def method_missing(method_id, *arguments)
    case method_id.to_s
      when /convert_complex_pattern_for_([_a-zA-Z]\w*)/
        attribute = $1
        convert_complex_pattern(attribute)
    else
      super
    end
  end
  # Protected Methods
  protected
  
  def convert_complex_pattern(attribute)
    timer = self.instance_variable_get("@attributes")[attribute]
    unless timer.nil? || timer.blank?
      if timer.to_s.match(COMPLEX_SECONDS_PATTERN)
        seconds = timer
        parsed_seconds_array = seconds.split(":")
        timer = (parsed_seconds_array.at(0).to_i * 3600) + (parsed_seconds_array.at(1).to_i * 60) + parsed_seconds_array.at(2).to_i
      end
    end
    attributes = self.instance_variable_get("@attributes")
    attributes[attribute] = timer
    self.instance_variable_set("@attributes",attributes)
  end
  
  def start_time_is_less_than_stop_time
    unless (self.video_start_time.nil? || self.video_stop_time.nil?) || (self.video_start_time.blank? || self.video_stop_time.blank?)
      errors.add_to_base("Start time must be less than Stop time") if self.video_start_time.to_i >= self.video_stop_time.to_i
    end
  end
  
  def reset_start_and_stop_times
    video = VideoPaper.find(self.video_paper_id).video
    unless video.nil?
      if self.video_start_time.to_i >= video.duration.to_i
        self.video_start_time = (video.duration.to_i - 1)
      end
      if self.video_stop_time.to_i > video.duration.to_i
        self.video_stop_time = video.duration.to_i
      end
    end
  end
  
end