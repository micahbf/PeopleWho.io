# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :currency do
    code "MSP"
    full_name "Martian Space Peso"
    rate 124.151059
  end
end
