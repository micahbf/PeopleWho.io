class User < ActiveRecord::Base
  attr_accessible :email, :name, :password
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :password, presence: true, on: :create

  after_initialize :ensure_session_token

  def self.find_by_credentials(email, password)
    return self.find_by_email(email).authenticate(password)
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
  end

  private

  def ensure_session_token
    self.session_token || self.class.generate_session_token
  end
end
