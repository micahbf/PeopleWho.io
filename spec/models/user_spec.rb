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
end
