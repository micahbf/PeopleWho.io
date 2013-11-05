class Bill < ActiveRecord::Base
  attr_accessible :description, :owner_id, :total
end
