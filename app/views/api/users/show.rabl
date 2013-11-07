object @user
attributes :id, :name, :email

child @splits do
  attributes :amount
  child :bill, object_root: false do
    attributes :description, :total, :settling
  end
end

glue @balance