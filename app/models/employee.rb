# frozen_string_literal: true
class Employee < ApplicationRecord
  has_many :salaries, dependent: :destroy
  accepts_nested_attributes_for :salaries, allow_destroy: true

  has_many :payrolls, dependent: :destroy
  has_many :statements, through: :payrolls, source: :statement

  def self.active
    Employee.where(end_date: nil)
      .or(Employee.where(end_date: Date.today.at_beginning_of_month..Date.today.at_end_of_month))
      .order(id: :desc)
  end

  def self.on_payroll(cycle_start, cycle_end)
    Employee
      .where("start_date <= ?", cycle_end)
      .where("end_date >= ? OR end_date is NULL", cycle_start)
      .order(id: :desc)
  end

  def calculate_until
    end_date || Date.today
  end

  def role
    ActiveDecorator::Decorator.instance.decorate(salaries.last).role_name
  end

  def email
    return personal_email if resigned? or company_email.blank?
    company_email
  end

  def resigned?
    return true if end_date
  end
end
