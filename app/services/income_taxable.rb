# frozen_string_literal: true
module IncomeTaxable
  # TODO: 需能區分 薪資所得 兼職薪資所得 執行業務所得
  # 薪資所得：employee.regular?
  # 兼職薪資所得：
  # 執行業務所得：income_9a?

  def income_9a?
    return false if payroll.employee.regular?
    return false if insuranced?
    income > 20000
  end

  def income_50?
  end

  def tax_9a
    (income * tax_rate).round
  end

  private

  def insuranced?
    salary.labor_insurance.positive?
  end

  def income
    IncomeService.new(payroll, salary).run.values.reduce(:+)
  end

  def tax_9a_rate
    0.1
  end

  def minimum_wage
    date = Date.new(payroll.year, payroll.month, 1)
    if date >= Date.new(2018, 1, 1)
      22000
    elsif date >= Date.new(2017, 1, 1)
      21009
    elsif date >= Date.new(2016, 10, 1)
      20008
    elsif date >= Date.new(2014, 7, 1)
      19273
    elsif date >= Date.new(2014, 1, 1)
      19047
    else
      18780 # 再往下寫沒意義
    end
  end
end
