module ApplicationHelper
  def int_to_decimal(int)
    "%0.2f" % (int / 100).round(2)
  end
end
