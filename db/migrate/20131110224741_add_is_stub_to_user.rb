class AddIsStubToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_stub, :boolean, default: false, null: false
  end
end
