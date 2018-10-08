# frozen_string_literal: true
class Salary < ApplicationRecord
  include Givenable

  belongs_to :employee
  after_commit :update_payrolls_on_date_change, if: :saved_change_to_effective_date?

  ROLE = {
    "老闆": "boss",
    "正職": "regular",
    "約聘": "contractor",
    "實習/工讀": "parttime",
    "顧問/講師": "advisor",
    "留職停薪": "absent",
  }.freeze

  TAX_CODE = { "薪資": "50", "執行專業所得": "9a" }.freeze
  CYCLE = { "一般": "normal", "工作天": "business" }.freeze

  class << self
    def by_payroll(employee, cycle_start, cycle_end)
      return if employee.end_date and employee.end_date < cycle_start
      where("employee_id = ? AND effective_date < ?", employee.id, cycle_end)
        .ordered
        .take
    end

    def ordered
      order(effective_date: :desc)
    end
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

  private

  def update_payrolls_on_date_change
    employee.payrolls.between(payroll_start_point, payroll_end_point).map do |payroll|
      salary = Salary.by_payroll(
        employee, Date.new(payroll.year, payroll.month, 1), Date.new(payroll.year, payroll.month, -1)
      )
      payroll.update(salary: salary)
    end
  end

  def payroll_start_point
    if effective_date > effective_date_before_last_save
      effective_date_before_last_save
    else
      effective_date
    end
  end

  def payroll_end_point
    if effective_date > effective_date_before_last_save
      effective_date
    else
      effective_date_before_last_save
    end
  end
end
