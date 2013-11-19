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

  describe "Class methods" do
    describe "::sum_for_user" do
      let(:user) { FactoryGirl.create(:user) }

      context "given an empty split array and a user" do
        it "returns 0" do
          expect(BillSplit.sum_for_user([], user)).to eq 0
        end
      end

      context "given an array of BillSplits and a user" do
        let(:bill_splits) do
          [].tap do |bill_splits|
            3.times do
              credit = FactoryGirl.create(:bill, owner: user)
              bill_splits << FactoryGirl.create(:bill_split, bill: credit)
            end

            2.times do
              debit = FactoryGirl.create(:bill)
              bill_splits << FactoryGirl.create(:bill_split, bill: debit, debtor: user)
            end
          end
        end

        it "should return the sum of credits minus the sum of debits" do
          expect(BillSplit.sum_for_user(bill_splits, user)).to eq 5000
        end
      end
    end
  end

  describe "Instance methods" do
    subject(:bill_split) { FactoryGirl.build(:bill_split) }

    describe "#decimal_amount" do
      it "returns the total as a formatted string" do
        expect(bill_split.decimal_amount).to eq "50.00"
      end
    end

    describe "#decimal_amount=" do
      context "given a string" do
        it "takes a whole number and sets the total correctly" do
          bill_split.decimal_amount = "2924"
          expect(bill_split.amount).to eq 292400
        end

        it "takes a decimal amount and sets the total correctly" do
          bill_split.decimal_amount = "424.21"
          expect(bill_split.amount).to eq 42421
        end

        it "drops decimals past the second position" do
          bill_split.decimal_amount = "4.12415"
          expect(bill_split.amount).to eq 412
        end
      end

      context "given a float" do
        it "multiplies times 100 and sets the integer total" do
          bill_split.decimal_amount = 25.12
          expect(bill_split.amount).to eq 2512
        end
      end
    end

    describe "#debtor_email=" do
      let(:user) { FactoryGirl.create(:user) }
      before { bill_split.debtor_id = nil }

      context "given an existing user email" do
        it "sets the debtor_id to that user's id" do
          bill_split.debtor_email = user.email
          expect(bill_split.debtor_id).to eq user.id
        end
      end

      context "given a non-existant user email" do
        it "creates a stub user" do
          expect{bill_split.debtor_email = "abc@def.com"}.to change{User.count}.by(1)
        end

        it "sets the debtor_id to the new user's id" do
          bill_split.debtor_email = "abc@xyz.com"
          expect(bill_split.debtor_id).to eq User.last.id
        end
      end
    end
  end
end
