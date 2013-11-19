require 'spec_helper'

describe UserGroupMembership do
  describe "Validations" do
    subject(:membership) { FactoryGirl.build(:user_group_membership) }

    it "has a valid factory" do
      expect(membership).to be_valid
    end

    it "must have a user" do
      membership.user_id = nil
      expect(membership).not_to be_valid
    end

    it "must have a group" do
      membership.group_id = nil
      expect(membership).not_to be_valid
    end

    it "must have a unique user-group combination" do
      other_membership = FactoryGirl.create(:user_group_membership,
                                            group_id: membership.group_id,
                                            user_id: membership.user_id)

      expect(membership).not_to be_valid
    end
  end
end
