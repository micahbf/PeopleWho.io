require 'spec_helper'

describe Bill do

  describe "Validations" do
    let(:bill) { FactoryGirl.build(:bill) }
    it "should have a valid factory" do
      expect(bill).to be_valid
    end

    it "must have an owner" do
      bill.owner_id = nil
      expect(bill).not_to be_valid
    end

    it "must have a total amount" do
      bill.total = bill
      expect(bill).not_to be_valid
    end

    it "sum of bill splits should be <= total" do
      bill.bill_splits.build([{
        amount: 7500,
        debtor_id: 1
        }, {
        amount: 7500,
        debtor_id: 2
      }])

      expect(bill).not_to be_valid
    end
  end
end
