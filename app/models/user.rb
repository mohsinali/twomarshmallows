class User < ApplicationRecord
  rolify

  ## Associations
  has_one :teacher_profile, class_name: "TeacherProfile", foreign_key: "user_id", dependent: :destroy
  # has_one :student_profile, class_name: "StudentProfile", foreign_key: "user_id"


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :custom_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## Validations
  validates :email, presence: true
  validates :password, presence: true, on: :create

  ## Hooks

  def profile
    if self.has_role?(:teacher)
      self.teacher_profile
    elsif self.has_role?(:student)
    end
  end

  def create_profile params
    if self.has_role?(:teacher)
      self.build_teacher_profile(params).save
    elsif self.has_role?(:student)
    end
  end

  def get_jwt_token
    payload = { data: {user: {id: self.id, email: self.email}} }
    payload[:exp] = (Time.now + 100.days).to_i
    JWT.encode payload, Settings.hmac_secret, 'HS256'
  end

  def valid_for_custom_authentication?(password)
    self.has_role?(:superadmin)
  end

end
