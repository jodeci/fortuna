# frozen_string_literal: true
class Payroll < ApplicationRecord
  include CollectionTranslatable

  belongs_to :employee
  delegate :name, :start_date, :end_date, to: :employee, prefix: true

  belongs_to :salary # 間接關聯，詳見 SalaryService
  delegate :monthly_wage, :hourly_wage, :labor_insurance, :health_insurance, :equipment_subsidy, :supervisor_allowance, :insured_for_health, to: :salary

  has_many :overtimes, dependent: :destroy
  accepts_nested_attributes_for :overtimes, allow_destroy: true

  has_many :extra_entries, dependent: :destroy
  accepts_nested_attributes_for :extra_entries, allow_destroy: true

  has_one :statement, dependent: :destroy
  delegate :excess_income, to: :statement

  FESTIVAL_BONUS = { "端午禮金": "dragonboat", "中秋禮金": "midautumn", "年終獎金": "newyear" }.freeze

  class << self
    def ordered
      Payroll.order(year: :desc, month: :desc)
    end

    def search_result
      Payroll
        .includes(:employee, :salary, :statement)
        .order(employee_id: :desc)
    end

    def personal_history
      Payroll.includes(:salary, :statement, statement: :corrections)
    end

    def details
      Payroll.includes(:salary, :extra_entries, :overtimes)
    end

    def yearly_vacation_refunds(year)
      Payroll
        .includes(:employee, :salary)
        .where("vacation_refund_hours > 0 and year = ?", year)
    end
  end

  def find_salary
    employee.find_salary(Date.new(year, month, 1), Date.new(year, month, -1))
  end

  def extra_income_of(income_type)
    extra_entries
      .where("income_type = ? AND amount > 0", income_type)
      .sum(:amount)
  end

  def extra_income
    extra_entries
      .where("amount > 0")
      .sum(:amount)
  end

  def extra_deductions
    extra_entries
      .where("amount < 0")
      .sum(:amount)
      .abs
  end
end
