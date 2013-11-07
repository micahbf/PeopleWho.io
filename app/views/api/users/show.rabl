object @user
attributes :id, :name, :email

node(:balance) { @balance }

child @splits, object_root: false do
  attributes :id, :amount
  child :bill, object_root: false do
    attributes :id, :description, :total, :settling, :created_at
  end
end