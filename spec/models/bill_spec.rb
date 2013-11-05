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

    it "must have at least one bill_split" do
      bill.bill_splits = []
      expect(bill).not_to be_valid
    end

    its "should have a total > the number of bill_splits" do
      bill.total = 1
      expect(bill).not_to be_valid
    end
  end
end
