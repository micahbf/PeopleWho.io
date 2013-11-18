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
end
