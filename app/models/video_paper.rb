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

  ###################################
  # Callbacks
  ###################################
  after_create :construct_video_paper_sections


  ##################################
  # instance methods
  ##################################

  # Public Methods
  def unshare(user_id)
    retval = false
    user = User.find(user_id)
    
    unless user.nil?
      paper = self.shared_papers.find_by_user_id(user.id)
      retval = true if paper.destroy
    end
    retval
  end
  ##
  # The one controller action that shares 
  def share(shared_paper_params)
    retval = false
    shared_paper = SharedPaper.new(shared_paper_params)
    shared_paper.video_paper = self
    if shared_paper.save
      ShareMailer.deliver_share_email(shared_paper.user,shared_paper.video_paper,self.user,shared_paper.notes)
    end
    shared_paper
  end
  
# Protected Methods
protected 

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
