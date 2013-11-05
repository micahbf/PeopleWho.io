# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill do
    owner_id 1
    total 1
    description "MyString"
  end
end
