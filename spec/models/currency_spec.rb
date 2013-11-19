require 'spec_helper'

describe Currency do
  describe "Validations" do
    subject(:currency) { FactoryGirl.build(:currency) }

    it "has a valid factory" do
      expect(currency).to be_valid
    end

    it "must have a currency code" do
      currency.code = nil
      expect(currency).not_to be_valid
    end

    it "must have a name" do
      currency.full_name = nil
      expect(currency).not_to be_valid
    end

    it "must have a rate" do
      currency.rate = nil
      expect(currency).not_to be_valid
    end

    it "rate must be a number" do
      currency.rate = "abc"
      expect(currency).not_to be_valid
    end
  end
end
