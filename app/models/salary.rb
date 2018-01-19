# frozen_string_literal: true
class Salary < ApplicationRecord
  default_scope { order(effective_date: :desc) }
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

  def self.by_payroll(employee, cycle_start, cycle_end)
    return if employee.end_date and employee.end_date < cycle_start
    find_by("employee_id = ? AND effective_date < ?", employee.id, cycle_end)
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
    labor_insurance.positive?
  end

  def contractor?
    role == "contractor"
  end
end
