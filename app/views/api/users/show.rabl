object @user
attributes :id, :name, :email

node(:balance) { @balance }

child @splits, object_root: false do
  attributes :amount
  child :bill, object_root: false do
    attributes :description, :total, :settling
  end
end