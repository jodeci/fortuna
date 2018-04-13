# frozen_string_literal: true
module PayrollDecorator
  def payment_period
    "#{year}-#{sprintf('%02d', month)}"
  end
end
