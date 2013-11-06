class BillSplit < ActiveRecord::Base
  attr_accessible :amount, :bill_id, :debtor_id, :decimal_amount

  validates :amount, :bill, :debtor, presence: true

  belongs_to :bill
  belongs_to :debtor, class_name: "User"

  def self.sum_for_user(splits, user)
    return 0 if splits.empty?

    user_id = user.id

    splits.reduce(0) do |sum, split|
      if split.debtor_id == user_id
        sum -= split.amount
      elsif split.bill.owner_id == user_id
        sum += split.amount
      end

      sum
    end
  end

  def decimal_amount
    if amount
      return Utilities::int_to_decimal(amount)
    else
      return nil
    end
  end

  def decimal_amount= (decimal)
    self.amount = Utilities::decimal_to_int(decimal)
  end
end