class UserGroup < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true

  has_many :user_group_memberships, foreign_key: :group_id, inverse_of: :group
  has_many :users, through: :user_group_memberships

  has_many :bills
end
