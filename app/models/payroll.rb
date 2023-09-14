# frozen_string_literal: true
class Payroll < ApplicationRecord
  include CollectionTranslatable

  belongs_to :employee
  delegate :name, to: :employee, prefix: true

  belongs_to :salary # 間接關聯，詳見 SalaryService
  delegate :monthly_wage, :hourly_wage, :labor_insurance, :health_insurance, :equipment_subsidy, :supervisor_allowance, :commuting_subsidy, :insured_for_health, to: :salary

  has_many :overtimes, dependent: :destroy
  accepts_nested_attributes_for :overtimes, allow_destroy: true

  has_many :extra_entries, dependent: :destroy
  accepts_nested_attributes_for :extra_entries, allow_destroy: true

  has_one :statement, dependent: :destroy
  delegate :excess_income, to: :statement

  FESTIVAL_BONUS = { "端午禮金": "dragonboat", "中秋禮金": "midautumn", "年終獎金": "newyear" }.freeze

  scope :ordered, -> { order(year: :desc, month: :desc) }
  scope :search_result, -> { includes(:employee, :salary, :statement).order(employee_id: :desc) }
  scope :personal_history, -> { includes(:salary, :statement) }
  scope :details, -> { includes(:salary, :extra_entries, :overtimes) }

  scope :yearly_vacation_refunds, ->(year) {
    includes(:employee, :salary)
      .where("vacation_refund_hours > 0 and year = ?", year)
  }

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

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at employee_id festival_bonus festival_type id leavetime_hours month parttime_hours salary_id sicktime_hours updated_at vacation_refund_hours year]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[employee extra_entries overtimes salary statement]
  end
end
