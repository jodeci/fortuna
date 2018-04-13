# frozen_string_literal: true
module SalaryDecorator
  def cycle_name
    case cycle
    when "normal" then "一般"
    when "business" then "工作天"
    end
  end

  def role_name
    case role
    when "boss" then "老闆"
    when "regular" then "正職"
    when "contractor" then "約聘"
    when "advisor" then "顧問/講師"
    when "parttime" then "實習/工讀"
    when "absent" then "留職停薪"
    end
  end

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
