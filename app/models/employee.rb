# frozen_string_literal: true
class Employee < ApplicationRecord
  include CollectionTranslatable

  has_many :salaries, dependent: :destroy
  accepts_nested_attributes_for :salaries, allow_destroy: true

  has_many :payrolls, dependent: :destroy
  has_many :statements, through: :payrolls, source: :statement

  BANK_TRANSFER_TYPE = { "薪資轉帳": "salary", "台幣轉帳": "normal" }.freeze

  class << self
    def ordered
      Employee.order(id: :desc)
    end

    def active
      Employee.where(end_date: nil)
        .or(Employee.where("end_date > ?", Date.today.at_beginning_of_month))
    end

    def inactive
      Employee.where("end_date < ?", Date.today.at_beginning_of_month)
    end

    def on_payroll(cycle_start, cycle_end)
      Employee
        .where("start_date <= ?", cycle_end)
        .where("end_date >= ? OR end_date is NULL", cycle_start)
    end
  end

  def calculate_until
    end_date || Date.today
  end

  def email
    return personal_email if resigned? or company_email.blank?
    company_email
  end

  def resigned?
    return true if end_date
  end
end
