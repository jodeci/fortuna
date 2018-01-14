# frozen_string_literal: true
class Employee < ApplicationRecord
  has_many :salaries, dependent: :destroy
  accepts_nested_attributes_for :salaries, allow_destroy: true

  has_many :payrolls, dependent: :destroy

  def self.active
    Employee.where("end_date >= now() OR end_date is NULL").order(id: :desc)
  end

  def self.on_payroll(cycle_start, cycle_end)
    Employee
      .where("start_date <= ?", cycle_end)
      .where("end_date >= ? OR end_date is NULL", cycle_start)
      .order(id: :desc)
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
end
