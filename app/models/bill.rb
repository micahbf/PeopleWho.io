class Bill < ActiveRecord::Base
  attr_accessible :description,
                  :owner_id,
                  :total,
                  :decimal_total,
                  :bill_splits_attributes,
                  :settling,
                  :group_id,
                  :orig_currency_code,
                  :orig_currency_total

  before_validation :perform_currency_conversion, on: :create
  before_validation :default_settling_to_false
  before_save :maybe_split_with_group

  validates :owner, :total, presence: true
  validates :total, numericality: { only_integer: true }
  validates :decimal_total, numericality: true, allow_blank: true
  validate :presence_of_description_unless_settling
  validate :total_greater_than_num_bill_splits
  validate :bill_splits_sum_not_greater_than_total
  validate :settling_has_exactly_one_split

  belongs_to :owner, class_name: "User"
  belongs_to :group, class_name: "UserGroup"
  belongs_to :original_currency, class_name: "Currency",
                                 foreign_key: :orig_currency_code,
                                 primary_key: :code

  has_many :bill_splits, inverse_of: :bill, dependent: :destroy
  accepts_nested_attributes_for :bill_splits

  def self.create_settle!(owed_user, paying_user)
    balance = owed_user.balance_with(paying_user)
    if balance <= 0
      raise "owed_user balance must be positive"
    end

    bill = Bill.new({
      settling: true,
      owner_id: paying_user.id,
      total: balance
    })

    bill.bill_splits.build({
      debtor_id: owed_user.id,
      amount: balance
    })
    
    if bill.save!
      return bill
    else
      return false
    end
  end

  def decimal_total
    if total
      return Utilities::int_to_decimal(total)
    else
      return nil
    end
  end

  def decimal_total= (decimal)
    self.total = Utilities::decimal_to_int(decimal)
  end

  def bill_split_sum
    bill_splits.map { |bs| bs.amount }.reduce(:+)
  end

  def split_remainder
    total - bill_split_sum
  end

  def in_group?
    !! self.group_id
  end

  private

  def total_greater_than_num_bill_splits
    if (total && total <= bill_splits.count)
      errors[:total] << "must be greater than the number of splits"
    end
  end

  def bill_splits_sum_not_greater_than_total
    if (!bill_splits.empty? && bill_split_sum > total)
      errors[:total] << "must be greater than the sum of the splits"
    end
  end

  def presence_of_description_unless_settling
    if (!settling && description.blank?)
      errors[:description] << "can't be blank"
    end
  end

  def settling_has_exactly_one_split
    if(settling && bill_splits.length != 1)
      errors[:bill_splits] << "must have exactly one split to settle"
    end
  end

  def default_settling_to_false
    self.settling = self.settling || false
    # Returning false will halt the validation chain,
    # so true is returned to ensure its continuation
    true
  end

  def maybe_split_with_group
    if self.group
      members = self.group.users.all
      other_members = members.reject { |m| m.id == self.owner_id }

      split_amounts = randomized_split_amounts(self.total, members.count)

      split_attrs_array = other_members.map do |member|
        base_hash = { amount: split_amounts.pop, debtor_id: member.id }
        if (self.orig_currency_code != 'USD')
          base_hash.merge!({orig_amount: self.orig_currency_total / members.count})
        end
        base_hash
      end

      self.bill_splits.build(split_attrs_array)
    end
  end

  def randomized_split_amounts(total, num_splits)
    base_split_amount = total / num_splits
    base_remainder = total % num_splits

    return [base_split_amount] * num_splits if base_remainder == 0

    [].tap do |extra_cents|
      base_remainder.times { extra_cents << 1 }
      (num_splits - base_remainder).times { extra_cents << 0 }
    end.shuffle.map { |a| a += base_split_amount }
  end

  def perform_currency_conversion
    self.orig_currency_code ||= 'USD'
    self.orig_currency_total ||= self.total

    if (self.orig_currency_code != 'USD')
      orig_currency = Currency.find_by_code(orig_currency_code)
      self.total = (self.orig_currency_total.to_f / orig_currency.rate).round

      self.bill_splits.each do |bill_split|
        bill_split.orig_amount = bill_split.amount
        bill_split.amount = (bill_split.amount.to_f / orig_currency.rate).round
      end
    end
  end
end
