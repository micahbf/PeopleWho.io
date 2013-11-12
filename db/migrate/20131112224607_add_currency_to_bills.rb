class AddCurrencyToBills < ActiveRecord::Migration
  def change
    add_column :bills, :orig_currency_code, :string
    add_column :bills, :orig_currency_total, :integer
  end
end
