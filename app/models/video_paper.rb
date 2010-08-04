class VideoPaper < ActiveRecord::Base
  
  ###################################
  # Associations
  ###################################
  belongs_to :user, :foreign_key=> "owner_id"
  has_many :sections
  has_one :video
  has_many :shared_papers  
  has_many :users, :through=>:shared_papers, :uniq=>true

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
    
    Settings.sections.each do |section_setting|
      section = Section.new
      section.video_paper = self
      section.title = section_setting[1]["title"]
      section.save
    end
    
    logger.debug("\nFinished constructing sections for video paper id: #{self.id.to_s} \n\n")
  end
  
end
