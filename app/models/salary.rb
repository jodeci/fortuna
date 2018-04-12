# frozen_string_literal: true
class Salary < ApplicationRecord
  belongs_to :employee

  # TODO: validations
  # role.regular
  #   必填 monthly_wage, health_insurance, labor_insurance
  #   限制 commuting_subsidy: 0, tax_code: 50, hourly_wage: 0
  #   可填 equipment_subsidy, supervisor_allowance
  # role.contractor
  #   必填 monthly_wage
  #   條件 tax_code: 9a => labor_insurance: 0, health_insurance: 0
  #   限制 commuting_subsidy: 0, supervisor_allowance: 0, equipment_subsidy: 0, hourly_wage: 0
  # role.parttime
  #   必填 hourly_wage
  #   限制 supervisor_allowance: 0, equipment_subsidy: 0, monthly_wage: 0
  #   可填 commuting_subsidy

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

  def insuranced?
    return true if boss?
    labor_insurance.positive?
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

  def absent?
    role == "absent"
  end
end
