module ApplicationHelper
  def int_to_decimal(int)
    (int / 100).round(2)
  end
end
