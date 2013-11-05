class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer :owner_id, null: false
      t.integer :total
      t.string :description

      t.timestamps
    end
    add_index :bills, :owner_id
  end
end
