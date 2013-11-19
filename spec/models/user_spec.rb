require 'spec_helper'

describe User do
  describe "Validations" do
    it "should have a valid factory" do
      expect(FactoryGirl.build(:user)).to be_valid
    end

    context "on a new user" do
      let(:user) { FactoryGirl.build(:user) }

      it "should not be valid without an email" do
        user.email = nil
        expect(user).not_to be_valid
      end

      it "should not be valid with no password" do
        user.password, user.password_confirmation = nil, nil
        expect(user).not_to be_valid
      end

      it "should not be valid with a short password" do
        user.password = user.password_confirmation = "pass"
        expect(user).not_to be_valid
      end

      it "should not be valid with mismatching password and confirmation" do
        user.password = "password1"
        user.password_confirmation = "password2"
        expect(user).not_to be_valid
      end
    end

    context "on an existing user" do
      let(:user) do
        u = FactoryGirl.create(:user)
        User.find u.id
      end

      it "should be valid with no changes" do
        expect(user).to be_valid
      end

      it "should not be valid with an empty password" do
        user.password = user.password_confirmation = ""
        expect(user).not_to be_valid
      end

      it "should be valid with a new password" do
        user.password = user.password_confirmation = "newpass"
        expect(user).to be_valid
      end
    end
  end

  describe "#display_name" do
    subject(:user) { FactoryGirl.build(:user) }

    it "returns the name if name is given" do
      expect(user.display_name).to eq(user.name)
    end

    it "returns the email if no name is given" do
      user.name = nil
      expect(user.display_name).to eq(user.email)
    end
  end

  describe "balance and bill methods" do
    subject(:user) { FactoryGirl.create(:user) }
    let(:owes_money) { FactoryGirl.create(:user) }
    let(:is_owed_money) { FactoryGirl.create(:user) }

    before do
      credit = FactoryGirl.create(:bill, owner: user)
      FactoryGirl.create(:bill_split, bill: credit, debtor: owes_money)

      debit = FactoryGirl.create(:bill, owner: is_owed_money)
      FactoryGirl.create(:bill_split, bill: debit, debtor: user)
    end

    describe "#user_ids_with_outstanding_balance" do
      it "should return a hash" do
        expect(user.user_ids_with_outstanding_balance).to be_a(Hash)
      end

      it "should include the ID of a user who owes money" do
        expect(user.user_ids_with_outstanding_balance).to include(owes_money.id)
      end

      it "should have a positive balance with a user who owes money" do
        expect(user.user_ids_with_outstanding_balance[owes_money.id]).to be > 0
      end

      it "should include the ID of a user who is owed money" do
        expect(user.user_ids_with_outstanding_balance).to include(is_owed_money.id)
      end

      it "should have a negative balance with a user who is owed money" do
        expect(user.user_ids_with_outstanding_balance[is_owed_money.id]).to be < 0
      end
    end

    describe "#users_with_outstanding_balance" do
      it "should return a hash" do
        expect(user.users_with_outstanding_balance).to be_a(Hash)
      end

      it "should have User objects as keys" do
        expect(user.users_with_outstanding_balance.keys.first).to be_a(User)
      end
    end

    describe "#balance_with" do
      it "should return postive numbers for people who owe money" do
        expect(user.balance_with(owes_money)).to be > 0
      end

      it "should return negative numbers for people who are owed money" do
        expect(user.balance_with(is_owed_money)).to be < 0
      end
    end

    describe "#splits_with" do
      it "should return an array" do
        expect(user.splits_with(is_owed_money)).to be_an(Array)
      end

      it "should return bill splits with others as the debtor" do
        expect(user.splits_with(owes_money)).to have(1).item
      end

      it "should return bill splits with the user as the debtor" do
        expect(user.splits_with(is_owed_money)).to have(1).item
      end
    end
  end
end
