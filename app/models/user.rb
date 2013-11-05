class User < ActiveRecord::Base
  attr_accessible :email, :name
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
end
