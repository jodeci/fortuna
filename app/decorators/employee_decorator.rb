# frozen_string_literal: true
module EmployeeDecorator
  def bank_transfer
    case bank_transfer_type
    when "salary" then "薪資轉帳"
    when "ntd" then "台幣轉帳"
    end
  end
end
