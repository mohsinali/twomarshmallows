class User < ApplicationRecord
  rolify
  acts_as_taggable_on :interests

  ## Associations
  has_one :teacher_profile, class_name: "TeacherProfile", foreign_key: "user_id", dependent: :destroy
  has_one :student_profile, class_name: "StudentProfile", foreign_key: "user_id", dependent: :destroy
  has_many :languages, class_name: "UserLanguage", foreign_key: "user_id", dependent: :destroy
  has_many :students, class_name: "StudentProfile", foreign_key: "teacher_id", dependent: :destroy


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :custom_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## Validations
  validates :email, presence: true
  validates :password, presence: true, on: :create

  ## Scopes
  scope :active, ->{ where(is_active: true) }
  scope :inactive, ->{ where(is_active: false) }

  ## Hooks

  def active_for_authentication?
    #remember to call the super
    #then put our own check to determine role is not "contact" using
    #rolify method "has_role?(:contact)"

    super and !self.has_role?(:student)
  end

  def valid_for_custom_authentication?(password)
    self.has_role?(:superadmin) && self.valid_password?(password)
  end

  def profile
    if self.has_role?(:teacher)
      self.teacher_profile
    elsif self.has_role?(:student)
      self.student_profile
    end
  end

  def role
    self.roles.last.name
  end

  def create_profile params, options = {}
    if self.has_role?(:teacher)
      self.build_teacher_profile(params).save

    elsif self.has_role?(:student)
      student_profile = self.build_student_profile(params)
      student_profile.teacher_id = options[:teacher_id]
      student_profile.save
    end
  end

  def has_avatar?
    avatar = Picture.find_by(imageable_id: self.profile.id)
    !avatar.blank?
  end

  def get_jwt_token
    payload = { data: {user: {id: self.id, email: self.email}} }
    payload[:exp] = (Time.now + 100.days).to_i
    JWT.encode payload, Settings.hmac_secret, 'HS256'
  end

end
