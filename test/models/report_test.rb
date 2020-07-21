# frozen_string_literal: true
require "test_helper"

class ReportTest < ActiveSupport::TestCase
  def test_scope_years
    prepare_report(year: 2016, month: 1, tax_code: "50")
    Timecop.freeze(Date.new(2018, 12, 19)) do
      assert_equal [2016, 2017, 2018, 2019], Report.years
    end
  end

  def test_scope_ordered
    prepare_scope_ordered
    assert Report.ordered.each_cons(2).all? do |first, second|
      compare_order(first, second)
    end
  end

  def test_scope_salary_income
    prepare_report(year: 2017, month: 12, tax_code: "50")
    prepare_report(year: 2018, month: 1, tax_code: "50")
    prepare_report(year: 2018, month: 2, tax_code: "50")

    assert_equal 1, Report.salary_income(2017).count
    assert_equal 2, Report.salary_income(2018).count
  end

  def test_scope_service_income
    prepare_report(year: 2017, month: 12, tax_code: "9a")
    prepare_report(year: 2018, month: 1, tax_code: "9a")
    prepare_report(year: 2018, month: 2, tax_code: "9a")

    assert_equal 0, Report.service_income(2017).count
    assert_equal 3, Report.service_income(2018).count
  end

  def test_scope_sum_by_month
    prepare_report(year: 2018, month: 1, tax_code: "50")
    prepare_report(year: 2018, month: 1, tax_code: "50")
    prepare_report(year: 2018, month: 1, tax_code: "9a")

    assert_equal 58000, Report.sum_by_month(year: 2018, month: 1, tax_code: "50")
    assert_equal 29000, Report.sum_by_month(year: 2018, month: 1, tax_code: "9a")
  end

  def test_scope_sum_by_festival
    prepare_festival_report(month: 6, festival: "dragonboat", amount: 1000)
    prepare_festival_report(month: 6, festival: "dragonboat", amount: 1000)
    prepare_festival_report(month: 9, festival: "midautumn", amount: 3000)

    assert_equal 2000, Report.sum_by_festival(2018, :dragonboat)
    assert_equal 3000, Report.sum_by_festival(2018, :midautumn)
  end

  def test_scope_sum_salary_income_for
    prepare_sum_report(month: 1, tax_code: "50", employee: employee)
    prepare_sum_report(month: 2, tax_code: "50", employee: employee)
    prepare_sum_report(month: 3, tax_code: "50", employee: employee)

    assert_equal 90000, Report.sum_salary_income_for(2018, employee.id)
  end

  def test_scope_sum_service_income_for
    prepare_sum_report(month: 1, tax_code: "9a", employee: employee)
    prepare_sum_report(month: 2, tax_code: "9a", employee: employee)
    prepare_sum_report(month: 3, tax_code: "9a", employee: employee)

    assert_equal 90000, Report.sum_service_income_for(2018, employee.id)
  end

  def test_adjusted_amount
    prepare_adjusted_report
    assert_equal 19510, Report.first.adjusted_amount
  end

  private

  def prepare_report(year:, month:, tax_code:)
    create(
      :payroll,
      year: year,
      month: month,
      festival_bonus: 1000,
      salary: build(:salary, tax_code: tax_code, employee: build(:employee), term: build(:term)),
      employee: build(:employee)
    ) do |payroll|
      create(:statement, payroll: payroll, amount: 30000) do |statement|
        create(:correction, statement: statement)
      end
    end
  end

  def prepare_adjusted_report
    create(
      :payroll,
      festival_bonus: 10000,
      salary: build(:salary, employee: build(:employee), term: build(:term)),
      employee: build(:employee)
    ) do |payroll|
      create(:statement, payroll: payroll, amount: 30000, subsidy_income: 500, correction: 10)
    end
  end

  def employee
    @employee ||= create(:employee) { |employee| build(:term, employee: employee) }
  end

  def prepare_sum_report(employee:, month:, tax_code:)
    create(
      :payroll,
      year: 2018,
      month: month,
      festival_bonus: 1000,
      salary: build(:salary, tax_code: tax_code, employee: employee, term: build(:term)),
      employee: employee
    ) do |payroll|
      create(:statement, payroll: payroll, amount: 30000) do |statement|
        create(:correction, statement: statement)
      end
    end
  end

  def prepare_festival_report(month:, festival:, amount:)
    create(
      :payroll,
      year: 2018,
      month: month,
      festival_bonus: amount,
      festival_type: festival,
      salary: build(:salary, employee: build(:employee), term: build(:term)),
      employee: build(:employee)
    ) do |payroll|
      create(:statement, payroll: payroll, amount: 30000) do |statement|
        create(:correction, statement: statement)
      end
    end
  end

  def prepare_scope_ordered
    3.times do
      prepare_report(year: 2017, month: 12, tax_code: 50)
      prepare_report(year: 2018, month: 1, tax_code: 50)
      prepare_report(year: 2018, month: 2, tax_code: 50)
    end
  end

  def compare_order(first, second)
    (first.employee_id <= second.employee_id) and (Date.new(first.year, first.month) <= Date.new(second.year, second.month))
  end
end
