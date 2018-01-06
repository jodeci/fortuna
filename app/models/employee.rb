# frozen_string_literal: true
class Employee < ApplicationRecord
  has_many :salaries, dependent: :destroy
  has_many :payrolls, dependent: :destroy

  # TODO: 根據發薪月份 對應到當月薪資設定
  def recent_salary
    salaries.last
  end

  def recent_payroll
    payrolls.last
  end
end
