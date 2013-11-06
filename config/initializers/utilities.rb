module Utilities
  def self.int_to_decimal(int)
    "%0.2f" % (int.to_f / 100).round(2)
  end

  def self.decimal_to_int(decimal)
    (decimal.to_f * 100).floor
  end
end