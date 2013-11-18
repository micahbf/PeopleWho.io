# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill_split do
    amount 5000

    association :debtor, factory: :user
  end
end
