# frozen_string_literal: true
# Salary 與 Payroll 為間接關聯，更新需要透過 SalaryService 同步
class Salary < ApplicationRecord
  include CollectionTranslatable

  belongs_to :employee
  belongs_to :term

  ROLE = {
    "老闆": "boss",
    "正職": "regular",
    "約聘": "contractor",
    "外包": "vendor",
    "時薪兼職": "parttime",
    "顧問/講師": "advisor",
  }.freeze

  TAX_CODE = { "薪資": "50", "執行專業所得": "9a" }.freeze
  CYCLE = { "一般": "normal", "工作天": "business" }.freeze

  scope :ordered, -> { order(effective_date: :desc).includes(:term) }
  scope :recent_for, ->(employee) { where(employee_id: employee.id).ordered.take }
  scope :effective_by, ->(cycle_end) { where("effective_date < ?", cycle_end).ordered.take }

  def income_with_subsidies
    (monthly_wage / monthly_wage_adjustment) + supervisor_allowance + equipment_subsidy + commuting_subsidy
  end

  # 一般薪資所得
  def regular_income?
    (tax_code == "50") && insured_for_labor.positive? && insured_for_health.positive?
  end

  # 兼職薪資所得（所得稅用）
  def parttime_income_uninsured_for_labor?
    (tax_code == "50") && insured_for_labor.zero?
  end

  # 兼職薪資所得（二代健保用）
  def parttime_income_uninsured_for_health?
    (tax_code == "50") && insured_for_health.zero?
  end

  # 執行業務所得
  def professional_service?
    tax_code == "9a"
  end

  def business_calendar?
    cycle == "business"
  end

  # 無僱傭關係的合作對象
  def partner?
    %w(vendor advisor).include? role
  end

  def insured_for_labor_and_uninsured_for_health?
    (tax_code == "50") && insured_for_health.zero? && insured_for_labor.positive?
  end
end
