# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill do
    total 10000
    description "MyString"
    association :owner, factory: :user

    after(:create) do |bill|
      FactoryGirl.create_list(:bill_split, 2, bill: bill, amount: 3333)
    end
  end
end
