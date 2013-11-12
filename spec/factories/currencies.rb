# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :currency do
    code "MyString"
    full_name "MyString"
    rate 1.5
  end
end
