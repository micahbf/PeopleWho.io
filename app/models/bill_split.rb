class BillSplit < ActiveRecord::Base
  attr_accessible :amount, :bill_id, :debtor_id, :paid, :decimal_amount

  validates :amount, :bill, :debtor, :paid, presence: true

  before_validation :default_paid_to_false

  belongs_to :bill
  belongs_to :debtor, class_name: "User"

  def decimal_amount
    if amount
      return (amount / 100).round(2)
    else
      return nil
    end
  end

  def decimal_amount= (decimal)
    self.amount = (decimal.to_f * 100).floor
  end

  private

  def default_paid_to_false
    self.paid ||= false
  end
end
