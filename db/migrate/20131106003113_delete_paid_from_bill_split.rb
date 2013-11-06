class DeletePaidFromBillSplit < ActiveRecord::Migration
  def up
    remove_column :bill_splits, :paid
  end

  def down
    add_column :bill_splits, :paid, :boolean, null: false, default: false
  end
end
