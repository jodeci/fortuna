# frozen_string_literal: true
module SalaryDecorator
  def tax_type
    case tax_code
    when "50" then "薪資"
    when "9a" then "執行業務所得"
    end
  end

  def wage_type
    monthly_wage.positive? ? "月薪" : "時薪"
  end

  def wage
    monthly_wage.positive? ? monthly_wage : hourly_wage
  end
end
