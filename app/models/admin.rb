class Admin < ActiveRecord::Base

  ###################################
  # AR Plugins/gems
  ###################################

  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable, :invitable,
         :encryptable, validate_on_invite: true

  # allows admins to invite people, I'm not sure if this needed since they are marked invitable
  include DeviseInvitable::Inviter

  ###################################
  # Validations
  ###################################

  validates_presence_of :first_name
  validates_presence_of :last_name


  ##################################
  # instance methods
  ##################################

  def name
    "#{self.first_name.downcase.titlecase} #{self.last_name.downcase.titlecase}"
  end

  def self.invite_key_fields
    [:first_name, :last_name, :email]
  end
end
