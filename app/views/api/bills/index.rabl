collection @bills, object_root: false
attributes :id, :owner_id, :total, :settling, :created_at

child :bill_splits, object_root: false do
  attributes :amount, :debtor_id
end