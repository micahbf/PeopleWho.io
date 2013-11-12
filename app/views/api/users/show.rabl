object @user
attributes :id, :name, :email

node(:balance) { @balance }

child @splits, object_root: false do
  attributes :id, :amount, :debtor_id
  child :bill, object_root: false do
    attributes :id, :description, :total, :settling, :created_at, :group_id
  end
end