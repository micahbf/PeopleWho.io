class CreateBillSplits < ActiveRecord::Migration
  def change
    create_table :bill_splits do |t|
      t.integer :bill_id, null: false
      t.integer :debtor_id, null: false
      t.boolean :paid, default: false, null: false
      t.integer :amount, null: false

      t.timestamps
    end
    add_index :bill_splits, :bill_id
    add_index :bill_splits, :debtor_id
  end
end
