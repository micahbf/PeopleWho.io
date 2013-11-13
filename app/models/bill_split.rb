class BillSplit < ActiveRecord::Base
  attr_accessible :amount,
                  :bill_id,
                  :debtor_id,
                  :debtor_email,
                  :decimal_amount,
                  :orig_amount

  validates :amount, :bill, :debtor, presence: true
  validates :amount, numericality: { only_integer: true }
  validates :decimal_amount, numericality: true, allow_blank: true
  validate :debtor_cant_be_same_as_bill_owner

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

  def decimal_amount=(decimal)
    self.amount = Utilities::decimal_to_int(decimal)
  end

  def debtor_email=(email)
    user = User.find_by_email(email)
    if user
      self.debtor_id = user.id
    else
      user = User.create_stub!(email)
      self.debtor_id = user.id
    end
  end

  private

  def debtor_cant_be_same_as_bill_owner
    if (debtor_id == bill.owner_id)
      errors[:debtor] << "can't be the same as bill owner"
    end
  end
end