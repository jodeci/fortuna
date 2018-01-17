# frozen_string_literal: true
module PayrollDecorator
  def payment_period
    "#{year}-#{sprintf('%02d', month)}"
  end

  def role
    case salary.role
    when "regular" then "正職"
    when "contractor" then "約聘"
    when "parttime" then "實習/工讀"
    end
  end
end
