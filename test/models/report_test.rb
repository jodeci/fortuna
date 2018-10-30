# frozen_string_literal: true
require "test_helper"

class ReportTest < ActiveSupport::TestCase
  def test_scope_years
    prepare_report(year: 2016, month: 1, tax_code: 50)
    prepare_report(year: 2017, month: 1, tax_code: 50)
    prepare_report(year: 2018, month: 1, tax_code: "9a")

    assert_equal Report.years.sort, [2016, 2017, 2018]
  end

  def test_scope_salary_income
    prepare_report(year: 2017, month: 12, tax_code: 50)
    prepare_report(year: 2018, month: 1, tax_code: 50)
    prepare_report(year: 2018, month: 2, tax_code: 50)

    assert_equal Report.salary_income(2017).count, 1
    assert_equal Report.salary_income(2018).count, 2
  end

  def test_scope_service_income
    prepare_report(year: 2017, month: 12, tax_code: "9a")
    prepare_report(year: 2018, month: 1, tax_code: "9a")
    prepare_report(year: 2018, month: 2, tax_code: "9a")

    assert_equal Report.service_income(2017).count, 0
    assert_equal Report.service_income(2018).count, 3
  end

  def test_scope_ordered
    prepare_scope_ordered
    assert Report.ordered.each_cons(2).all? do |first, second|
      compare_order(first, second)
    end
  end

  def test_adjusted_amount
    prepare_adjusted_report
    assert_equal Report.first.adjusted_amount, 19510
  end

  private

  def prepare_report(year:, month:, tax_code:)
    create(
      :payroll,
      year: year,
      month: month,
      salary: build(:salary, tax_code: tax_code, employee: build(:employee)),
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
      salary: build(:salary, employee: build(:employee)),
      employee: build(:employee)
    ) do |payroll|
      create(:statement, payroll: payroll, amount: 30000, subsidy_income: 500) do |statement|
        create(:correction, statement: statement, amount: 10)
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
