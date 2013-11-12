require 'currency_index'

class Currency < ActiveRecord::Base
  attr_accessible :code, :full_name, :rate

  def self.update_all
    @@currency_index ||= CurrencyIndex.new
    rates = @@currency_index.currency_rates

    rates.each do |code, rate|
      Currency.update_rate_or_create_new!(code, rate)
    end
  end

  def self.names_list
    if (@@currency_list)
      return @@currency_list
    else
      @@currency_index ||= CurrencyIndex.new
      @@currency_list = @@currency_index.currency_list
    end
  end

  private

  def self.update_rate_or_create_new!(code, rate)
    currency = Currency.find_by_code(code)

    if currency
      currency.update_attributes!({ rate: rate })
    else
      Currency.create!({
        code: code,
        full_name: Currency.names_list[code],
        rate: rate
      })
    end
  end
end