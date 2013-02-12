class User < ActiveRecord::Base
  
  ###################################
  # AR Plugins/gems
  ###################################
  
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable, :invitable,
         :encryptable

  ###################################
  # Associations
  ###################################
  
  has_many :my_video_papers, :foreign_key => 'owner_id', :class_name => 'VideoPaper'
  has_many :video_papers, :through=> :shared_papers, :uniq=>true
  has_many :shared_papers, :dependent => :destroy
  has_many :wysihat_files
  
  ###################################
  # Validations
  ###################################
  
  validates_presence_of :first_name
  validates_presence_of :last_name

  ##################################
  # instance methods
  ##################################
  
  #Public Methods
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name,:invitation_token  
  
  def name
    "#{self.first_name.titlecase} #{self.last_name.titlecase}"
  end
  
  def generate_reset_password_token!
    generate_reset_password_token && save(:validate => false)
    self.reset_password_token
  end
  
  def self.invite_key_fields 
    [:first_name, :last_name, :email]
  end
  
end
