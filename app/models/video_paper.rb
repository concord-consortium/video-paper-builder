class VideoPaper < ActiveRecord::Base
  
  ###################################
  # Associations
  ###################################
  belongs_to :user, :foreign_key=> "owner_id"
  has_many :sections
  has_one :video
  
  accepts_nested_attributes_for :sections

  ###################################
  # Validations
  ###################################
  validates_presence_of :title
  validates_presence_of :owner_id

  def after_create
    construct_video_paper_sections
  end
  
  def construct_video_paper_sections
    logger.debug("\nConstructing sections for video paper id: #{self.id.to_s} \n\n")
    
    @intro_section = Section.new :video_paper=> self, :title=>"Introduction"
    @intro_section.save!
    
    @getting_started_section = Section.new :video_paper=> self, :title=>"Getting Started"
    @getting_started_section.save!
    
    @inquiry_section = Section.new :video_paper=> self, :title=>"Inquiry"
    @inquiry_section.save!
    
    @wrapping_up_section = Section.new :video_paper=> self, :title=>"Wrapping up"
    @wrapping_up_section.save!
    
    @conclusion_section = Section.new :video_paper=> self, :title=>"Conclusion"
    @conclusion_section.save!
    
    logger.debug("\nFinished constructing sections for video paper id: #{self.id.to_s} \n\n")
  end
  
end
