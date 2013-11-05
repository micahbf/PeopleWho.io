class BillSplit < ActiveRecord::Base
  attr_accessible :amount, :bill_id, :debtor_id, :paid
end
