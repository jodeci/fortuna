# frozen_string_literal: true
module EmployeeDecorator
  def role_name
    case role
    when "regular" then "正職"
    when "contractor" then "約聘"
    when "parttime" then "實習/工讀"
    else "未定"
    end
  end
end
