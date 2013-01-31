class SharedPaper < ActiveRecord::Base
  attr_accessible :user_id, :notes

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
  validates_uniqueness_of :user_id, :scope=>:video_paper_id, :message=>"OMG WOW!"
  validate :user_exists

  ##################################
  # instance methods
  ##################################

# Protected Methods  
protected
  def user_exists
    all_user_ids = User.all.map(&:id)
    if !all_user_ids.include?(self.user_id)
      errors.add(:user_id,"User ID does not exist")
    end
  end
end
