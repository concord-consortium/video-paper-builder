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
  validates_presence_of :status

  ###################################
  # Callbacks
  ###################################
  after_create :construct_video_paper_sections

  ###################################
  # Named Scopes
  ###################################
  named_scope :owned_by, lambda { |owner| 
    { :conditions => { :owner_id => owner.id} }
  }
  
  ##################################
  # instance methods
  ##################################

  # Public Methods
  def format_created_date
    created_at = self.created_at
    created_at.strftime("%A %B #{created_at.day.ordinalize}, %Y")
  end
  
  def published?
    self.status == "published"
  end
  
  def publish!
    self.status = "published"
    save!
  end
  ##
  # The one controller action that shares 
  def share(shared_paper_params)
    retval = false
    shared_paper = SharedPaper.new(shared_paper_params)
    shared_paper.video_paper = self
    if shared_paper.save
      ShareMailer.deliver_share_email(shared_paper.user,shared_paper.video_paper,self.user,shared_paper.notes)
      retval = true
    end
    retval
  end
  
  def unpublished?
    self.status == "unpublished"
  end
  
  def unpublish!
    self.status = "unpublished"
    save!
  end
  
  def unshare(user_id)
    retval = false
    user = User.find(user_id)
    
    unless user.nil?
      paper = self.shared_papers.find_by_user_id(user.id)
      retval = true if paper.destroy
    end
    retval
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
