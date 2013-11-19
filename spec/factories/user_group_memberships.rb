# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_group_membership do
    association :user
    association :group, factory: :user_group
  end
end
