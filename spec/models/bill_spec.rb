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
      bill.total = nil
      expect(bill).not_to be_valid
    end

    it "total amount must be an integer" do
      bill.total = "abcd"
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

    it "must have a description when not settling" do
      bill.description = nil
      expect(bill).not_to be_valid
    end

    it "does not need a description when settling" do
      bill.settling = true
      bill.description = nil
      expect(bill).not_to be_valid
    end
  end

  describe "Instance methods" do
    subject(:bill) { FactoryGirl.build(:bill) }

    describe "#decimal_total" do
      it "returns the total as a formatted string" do
        expect(bill.decimal_total).to eq "100.00"
      end
    end

    describe "#decimal_total=" do
      context "given a string" do
        it "takes a whole number and sets the total correctly" do
          bill.decimal_total = "2924"
          expect(bill.total).to eq 292400
        end

        it "takes a decimal total and sets the total correctly" do
          bill.decimal_total = "424.21"
          expect(bill.total).to eq 42421
        end

        it "drops decimals past the second position" do
          bill.decimal_total = "4.12415"
          expect(bill.total).to eq 412
        end
      end
    end

    describe "#bill_split_sum" do
      it "returns 0 if there are no bill splits" do
        expect(bill.bill_split_sum).to eq 0
      end

      it "returns the sum of the amounts of its splits" do
        2.times { FactoryGirl.create(:bill_split, bill: bill, amount: 3000) }
        expect(bill.bill_split_sum).to eq 6000
      end
    end

    describe "#split_remainder" do
      it "returns the bill total if there are no bill splits" do
        expect(bill.split_remainder).to eq 10000
      end

      it "returns the bill total minus the sum of split amounts" do
        2.times { FactoryGirl.create(:bill_split, bill: bill, amount: 3000) }
        expect(bill.split_remainder).to eq 4000        
      end
    end
  end

  describe "Settling" do
    context "between users with an outstanding balance" do
      let(:owed_user) { FactoryGirl.create(:user) }
      let(:owing_user) { FactoryGirl.create(:user) }

      before do
        bill = FactoryGirl.create(:bill, owner: owed_user)
        FactoryGirl.create(:bill_split, bill: bill, debtor: owing_user)
        @balance = owed_user.balance_with(owing_user)
      end

      context "when initiated by the owing user" do
        it "raises an error" do
          expect { Bill.create_settle!(owing_user, owed_user) }.to raise_error RuntimeError
        end
      end

      context "when initiated by the owed user" do
        let(:settlement) { Bill.create_settle!(owed_user, owing_user) }
        subject { settlement }

        it "should be valid" do
          expect(settlement).to be_valid
        end

        its(:settling) { should eq true }
        its(:total) { should eq @balance }
        its(:owner_id) { should eq owing_user.id }

        it "should have exactly one bill split" do
          expect(settlement.bill_splits.count).to eq 1
        end

        describe "bill split" do
          let(:bill_split) { settlement.bill_splits.first }

          it "debtor should be owed user" do
            expect(bill_split.debtor_id).to eq owed_user.id
          end

          it "amount should equal the previously outstanding balance" do
            expect(bill_split.amount).to eq @balance
          end
        end
      end
    end
  end

  describe "Currency Conversion" do
    context "from a currency that is not USD" do
      let(:currency) { FactoryGirl.create(:currency) }
      subject(:bill) { FactoryGirl.build(:bill, orig_currency_code: currency.code) }
      let(:bill_split) { FactoryGirl.build(:bill_split) }
      
      before do
        bill.bill_splits << bill_split
        bill.save
      end

      it "should have a total converted to USD" do
        expect(bill.total).to eq(1000)
      end

      it "should save the original currency code" do
        expect(bill.orig_currency_code).to eq(currency.code)
      end

      it "should save the total in the original currency" do
        expect(bill.orig_currency_total).to eq(10000)
      end

      describe "bill splits" do

        it "should be converted to USD" do
          expect(bill_split.amount).to eq(500)
        end

        it "should save the amount in the original currency" do
          expect(bill_split.orig_amount).to eq(5000)
        end
      end
    end

    context "when the currency is unspecified" do
      subject(:bill) { FactoryGirl.create(:bill) }

      it "should default to USD" do
        expect(bill.orig_currency_code).to eq("USD")
      end

      it "should copy the amount to the original amount" do
        expect(bill.orig_currency_total).to eq(10000)
      end
    end
  end
end
