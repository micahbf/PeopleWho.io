# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :currency do
    code "MSP"
    full_name "Martian Space Peso"
    rate 10.0000
  end
end
