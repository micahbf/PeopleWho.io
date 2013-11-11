class AddGroupIdToBills < ActiveRecord::Migration
  def change
    add_column :bills, :group_id, :integer
    add_index :bills, :group_id
  end

end
