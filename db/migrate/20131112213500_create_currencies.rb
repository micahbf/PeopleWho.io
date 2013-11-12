class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :code, null: false
      t.string :full_name, null: false
      t.float :rate, null: false

      t.timestamps
    end
    add_index :currencies, :code, unique: true
  end
end
