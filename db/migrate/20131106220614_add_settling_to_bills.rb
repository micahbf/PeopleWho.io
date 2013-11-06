class AddSettlingToBills < ActiveRecord::Migration
  def change
    add_column :bills, :settling, :boolean
  end
end
