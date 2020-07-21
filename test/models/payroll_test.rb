# frozen_string_literal: true
require "test_helper"

class PayrollTest < ActiveSupport::TestCase
  def test_scope_ordered
    prepare_scope_ordered

    assert Payroll.ordered.each_cons(2).all? do |first, second|
      Date.new(first.year, first.month) <= Date.new(second.year, second.month)
    end
  end

  def test_scope_search_result
    5.times { create(:employee) }

    assert Payroll.search_result.each_cons(2).all? do |first, second|
      first.employee_id <= second.employee_id
    end
  end

  def test_scope_yearly_vacation_refunds
    5.times { prepare_vacations(year: 2017) }
    3.times { prepare_vacations(year: 2018) }

    assert_equal 5, Payroll.yearly_vacation_refunds(2017).count
    assert_equal 3, Payroll.yearly_vacation_refunds(2018).count
  end

  def test_scope_personal_history
    subject = prepare_scope_personal_history

    assert subject.first.association(:salary).loaded?
    assert subject.first.association(:statement).loaded?
  end

  def test_scope_details
    subject = prepare_scope_details

    assert subject.first.association(:salary).loaded?
    assert subject.first.association(:extra_entries).loaded?
    assert subject.first.association(:overtimes).loaded?
  end

  def test_extra_entries
    subject = prepare_extra_entries

    assert_equal 100, subject.extra_income_of("bonus")
    assert_equal 200, subject.extra_income_of("subsidy")
    assert_equal 500, subject.extra_income_of("salary")

    assert_equal 800, subject.extra_income
    assert_equal 10, subject.extra_deductions
  end

  private

  def prepare_scope_ordered
    create(:payroll, year: 2018, month: 1, employee: build(:employee), salary: build(:salary))
    create(:payroll, year: 2018, month: 6, employee: build(:employee), salary: build(:salary))
    create(:payroll, year: 2017, month: 12, employee: build(:employee), salary: build(:salary))
  end

  def prepare_scope_personal_history
    create(:payroll, salary: build(:salary), employee: build(:employee)) do |payroll|
      create(:statement, payroll: payroll) do |statement|
        build(:correction, statement: statement)
      end
    end
    Payroll.personal_history
  end

  def prepare_scope_details
    create(:payroll, salary: build(:salary), employee: build(:employee)) do |payroll|
      build(:extra_entry, payroll: payroll)
      build(:overtime, payroll: payroll)
    end
    Payroll.details
  end

  def payroll_with_employee(employee_id:)
    create(:payroll, employee: create(:employee, id: employee_id), salary: build(:salary))
  end

  def prepare_vacations(year:)
    create(:payroll, year: year, vacation_refund_hours: 1, employee: build(:employee), salary: build(:salary))
  end

  def prepare_extra_entries
    create(:payroll, employee: build(:employee), salary: build(:salary)) do |payroll|
      create(:extra_entry, amount: 100, income_type: "bonus", payroll: payroll)
      create(:extra_entry, amount: 200, income_type: "subsidy", payroll: payroll)
      create(:extra_entry, amount: 500, income_type: "salary", payroll: payroll)
      create(:extra_entry, amount: -10, income_type: "salary", payroll: payroll)
    end
  end
end
