# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill_split do
    bill_id 1
    debtor_id 1
    paid false
    amount 1
  end
end
