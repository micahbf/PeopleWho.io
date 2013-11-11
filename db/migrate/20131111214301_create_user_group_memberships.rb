class CreateUserGroupMemberships < ActiveRecord::Migration
  def change
    create_table :user_group_memberships do |t|
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
    add_index :user_group_memberships, :user_id
    add_index :user_group_memberships, :group_id
  end
end
