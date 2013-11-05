# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill do
    total 10000
    sequence :description do
      ["Drinks", "Dinner", "Gas", "Tickets"].sample
    end

    association :owner, factory: :user
  end
end
