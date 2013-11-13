class AddOriginalAmountToBillSplit < ActiveRecord::Migration
  def change
    add_column :bill_splits, :orig_amount, :integer
  end
end
