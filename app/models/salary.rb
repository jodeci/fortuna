# frozen_string_literal: true
class Salary < ApplicationRecord
  belongs_to :employee
  scope :ordered, -> { order(effective_date: :desc) }

  def self.by_payroll(employee, cycle_start, cycle_end)
    return if employee.end_date and employee.end_date < cycle_start
    where("employee_id = ? AND effective_date < ?", employee.id, cycle_end)
      .ordered
      .take
  end

  # 一般薪資所得
  def regular_income?
    tax_code == "50" and insuranced?
  end

  # 兼職薪資所得
  def parttime_income?
    tax_code == "50" and !insuranced?
  end

  # 執行業務所得
  def professional_service?
    tax_code == "9a"
  end

  def business_calendar?
    cycle == "business"
  end

  def insuranced?
    insured_for_labor.positive?
  end

  def boss?
    role == "boss"
  end

  def regular?
    role == "regular"
  end

  def contractor?
    role == "contractor"
  end

  def parttime?
    role == "parttime"
  end

  def advisor?
    role == "advisor"
  end

  def absent?
    role == "absent"
  end
end
