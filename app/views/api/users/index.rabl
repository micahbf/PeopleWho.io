object false

child @users_with_balances.keys do
  attributes :id, :name, :email
  node :balance do |user|
    @users_with_balances[user]
  end
end