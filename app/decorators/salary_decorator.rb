# frozen_string_literal: true
module SalaryDecorator
  def wage_type
    monthly_wage.positive? ? "月薪" : "時薪"
  end

  def wage
    monthly_wage.positive? ? monthly_wage : hourly_wage
  end
end
