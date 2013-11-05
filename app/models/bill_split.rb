class BillSplit < ActiveRecord::Base
  attr_accessible :amount, :bill_id, :debtor_id, :paid

  belongs_to :bill
  belongs_to :debtor, class_name: "User"
end
