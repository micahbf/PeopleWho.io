require 'spec_helper'

describe UserGroup do
  describe "Validations" do
    subject(:user_group) { FactoryGirl.build(:user_group) }

    it "has a valid factory" do
      expect(user_group).to be_valid
    end

    it "must have a name" do
      user_group.name = nil
      expect(user_group).not_to be_valid
    end
  end
end
