class Admin < ActiveRecord::Base
  
  ###################################
  # AR Plugins/gems
  ###################################  
  
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable, :invitable

  ###################################
  # Validations
  ###################################
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  
  ##################################
  # instance methods
  ##################################

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name
  
  def name
    "#{self.first_name.downcase.titlecase} #{self.last_name.downcase.titlecase}"
  end  
  
  ##################################
  # Class Methods
  #################################
  class << self
    ##
    # This is a bit of an ugly hack.  The deal is this.  The devise invitable method
    # creates a new user account with just the email.  We need it to create with a first/last name
    # too.  So here you are.
    def send_invitation(attributes={})
      invitable = self.find_or_initialize_by_email(attributes[:email])

      if invitable.new_record?
        invitable.first_name = attributes[:first_name]
        invitable.last_name = attributes[:last_name]
        invitable.errors.add(:email, :blank) if invitable.email.blank?
        invitable.errors.add(:email, :invalid) unless invitable.email.match /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
      else
        invitable.errors.add(:email, :taken) unless invitable.invited?
      end

      invitable.resend_invitation! if invitable.errors.empty?
      invitable
    end
  end  
end
