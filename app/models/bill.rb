class Bill < ActiveRecord::Base
  attr_accessible :description, :owner_id, :total

  belongs_to :owner, class_name: "User"
end
