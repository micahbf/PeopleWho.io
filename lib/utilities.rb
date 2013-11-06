module Utilities
  def int_to_decimal(int)
    "%0.2f" % (int / 100).round(2)
  end

  def decimal_to_int(decimal)
    (decimal.to_f * 100).floor
  end
end