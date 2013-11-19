require 'spec_helper'

describe BillSplit do
  describe "Validations" do
    subject(:bill_split) { FactoryGirl.build(:bill_split) }

    it "has a valid factory" do
      expect(bill_split).to be_valid
    end

    it "must have an amount" do
      bill_split.amount = nil
      expect(bill_split).not_to be_valid
    end

    it "amount must be an integer" do
      bill_split.amount = "anid"
      expect(bill_split).not_to be_valid
    end

    it "must have an associated bill" do
      bill_split.bill_id = nil
      expect(bill_split).not_to be_valid
    end

    it "must have an associated debtor" do
      bill_split.debtor_id = nil
      expect(bill_split).not_to be_valid
    end
  end
end
