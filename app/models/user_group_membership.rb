class UserGroupMembership < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  validates :group, :user, presence: true
  validates :user_id, uniqueness: { scope: :group_id }

  belongs_to :group, class_name: "UserGroup", foreign_key: :group_id
  belongs_to :user
end
