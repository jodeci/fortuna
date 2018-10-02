# frozen_string_literal: true
class ReportService
  attr_accessor :year, :income_type

  INCOME_TYPE = { "薪資+三節獎金": "salary", "勞務報酬": "service", "非經常性給予": "irregular" }.freeze

  def initialize(year, income_type)
    @year = year.to_i
    @income_type = income_type
  end

  def call
    employees_on_payroll.map do |employee|
      {
        name: employee.name,
        income: send("yearly_#{income_type}_income", employee),
      }
    end
  end

  def self.years
    Payroll.distinct.pluck(:year)
  end

  private

  def yearly_salary_income(employee)
    cells = []
    1.upto(12) { |month| cells << ReportCell.new(employee.payroll(year, month), income_type) }
    cells
  end

  def yearly_service_income(employee)
    cells = []
    12.times do |month|
      if month.zero?
        cells << ReportCell.new(employee.payroll(year - 1, 12), income_type)
      else
        cells << ReportCell.new(employee.payroll(year, month), income_type)
      end
    end
    cells
  end

  # TODO
  def yearly_irregular_income(employee)
    []
  end

  def employees_on_payroll
    Employee.on_payroll(year_start, year_end).order(id: :asc).select do |employee|
      employee.send("#{income_type}_income?", year)
    end
  end

  def year_start
    if income_type == :service
      Date.new(year - 1, 12, 1)
    else
      Date.new(year, 1, 1)
    end
  end

  def year_end
    if income_type == :service
      Date.new(year, 11, -1)
    else
      Date.new(year, 12, -1)
    end
  end
end

class ReportCell
  attr_accessor :payroll, :income_type

  def initialize(payroll, income_type)
    @payroll = payroll
    @income_type = income_type
  end

  def result
    send(income_type)
  end

  private

  # TODO: 三節獎需扣出另列一欄、加班費等免稅非經常性給予需扣除
  def salary
    if payroll.present? and payroll.salary.tax_code == "50"
      payroll.amount
    else
      0
    end
  end

  def service
    if payroll.present? and payroll.salary.tax_code == "9a"
      payroll.amount
    else
      0
    end
  end

  # TODO
  def irregular
    0
  end
end
