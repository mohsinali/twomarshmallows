class User < ApplicationRecord
  rolify
  paginates_per 10

  ## Associations  


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## Validations
  validates :email, presence: true
  validates :password, presence: true, on: :create

  ## Hooks


  def get_jwt_token
    payload = { data: {user: {id: self.id, email: self.email}} }
    payload[:exp] = (Time.now + 100.days).to_i
    JWT.encode payload, Settings.hmac_secret, 'HS256'
  end

end
