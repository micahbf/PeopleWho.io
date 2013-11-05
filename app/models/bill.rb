class Bill < ActiveRecord::Base
  attr_accessible :description, :owner_id, :total

  validates :owner, :total, presence: true
  validate :total_greater_than_num_bill_splits

  belongs_to :owner, class_name: "User"

  has_many :bill_splits

  private

  def total_greater_than_num_bill_splits
    if (total && total <= bill_splits.count)
      errors[:total] << "must be greater than the number of splits"
    end
  end
end
