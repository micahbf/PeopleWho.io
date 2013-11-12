class Currency < ActiveRecord::Base
  attr_accessible :code, :full_name, :rate
end
