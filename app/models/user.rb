class User < ActiveRecord::Base

  ###################################
  # AR Plugins/gems
  ###################################

  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable, :invitable,
         :encryptable, validate_on_invite: true
  devise :omniauthable, :omniauth_providers => Devise.omniauth_providers

  ###################################
  # Associations
  ###################################

  has_many :my_video_papers, :foreign_key => 'owner_id', :class_name => 'VideoPaper', :dependent => :destroy
  has_many :video_papers, -> { uniq }, :through=> :shared_papers
  has_many :shared_papers, :dependent => :destroy
  has_many :wysihat_files, :dependent => :destroy

  ###################################
  # Validations
  ###################################

  validates_presence_of :first_name
  validates_presence_of :last_name

  ##################################
  # Callbaks
  ##################################
  after_create :add_common_shared_paper

  ##################################
  # instance methods
  ##################################

  #Public Methods

  # Setup accessible (or protected) attributes for your model
  # TODO: figure out omni auth use
  # attr_accessible :email, :password, :password_confirmation, :first_name, :last_name,:invitation_token, :provider, :uid, :remember_me

  def name
    "#{self.first_name.titlecase} #{self.last_name.titlecase}"
  end

  def generate_reset_password_token!
    # TODO: Devise 3 changes how tokens are generated and stored and this no longer works
    # the code that uses this was already commented out in the admin/index.html.erb file.
    # Leaving the code in here so that maybe in final upgrade to Devise 4 this can be fixed
    # generate_reset_password_token! && save(:validate => false)
    # self.reset_password_token
    return "TODO: FIX!"
  end

  def self.invite_key_fields
    [:first_name, :last_name, :email]
  end

  comma do
    id
    created_at 'First Sign In'
    current_sign_in_at 'Most Recent Sign In'
    sign_in_count 'Number of Sign Ins'
    provider 'Initial Sign In Provider'
    first_name
    last_name
    email
    my_video_papers :size => 'Number of Papers'
    my_video_papers 'Last Paper: Title' do |papers|
      if papers.empty?
        ''
      else
        papers.last.title
      end
    end
    my_video_papers 'Last Paper: Video Length' do |papers|
      if papers.empty? || papers.last.video.nil?
        ''
      else
        papers.last.video.duration
      end
    end
    my_video_papers 'Last Paper: Last Text Edit' do |papers|
      if papers.empty? || papers.last.sections.empty?
        ''
      else
        papers.last.sections.sort{ |x,y| x.updated_at <=> y.updated_at}.last.updated_at
      end
    end
    my_video_papers 'Last Paper: Number of Shares' do |papers|
      if papers.empty?
        ''
      else
        papers.last.users.size
      end
    end
  end

  class <<self
    def find_for_omniauth(auth, schoology_realm = nil, schoology_realm_id = nil)

      if schoology_realm && schoology_realm_id && !SchoologyRealm.allowed?(schoology_realm, schoology_realm_id)
        raise "your #{schoology_realm} does not have access to this application"
      end

      if !auth.extra.in_authorized_realm?
        raise "you are not part of a class or group that has access to this application"
      end

      user = User.find_by_provider_and_uid auth.provider, auth.uid
      return user if user

      # the devise validatable model enforces unique emails, so no need find_all
      email = auth.info.email || "#{Devise.friendly_token[0,20]}@example.com"
      existing_user_by_email = User.find_by_email email

      if existing_user_by_email
        if User.find_by_email_and_provider email, auth.provider
          raise "a user with that email from that provider already exists"
        end
        # There is no authentication for this provider and user
        user = existing_user_by_email
      else
        # no user with this email, so make a new user with a random password
        pw = Devise.friendly_token.first(12)
        user = User.new do |u|
          u.first_name = auth.extra.first_name
          u.last_name = auth.extra.last_name
          u.email = email
          u.password = pw
          u.password_confirmation = pw
          u.provider = auth.provider
          u.uid = auth.uid
        end
        user.skip_confirmation!
        user.save
      end
      user
    end
  end

  protected

  def add_common_shared_paper
    if ENV['COMMON_SHARED_PAPER_ID'].present?
      paper = VideoPaper.find(ENV['COMMON_SHARED_PAPER_ID'])
      paper.users << self if paper
    end
  end
end
