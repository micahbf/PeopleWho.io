object false

child @users, object_root: false do
  attributes :id, :email, :name
end

child @users_with_balances.keys => :balances do
  node :user_id do |user|
    user
  end

  node :balance do |user|
    @users_with_balances[user]
  end
end