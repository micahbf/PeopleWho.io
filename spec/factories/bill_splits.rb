# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill_split do
    association :bill
    association :debtor, factory: user
    paid false
    amount 1
  end
end
