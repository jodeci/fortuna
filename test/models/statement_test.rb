# frozen_string_literal: true
require "test_helper"

class StatementTest < ActiveSupport::TestCase
  def test_scope_paid
    3.times { prepare_statement(year: 2018, month: 1, amount: 100) }
    2.times { prepare_statement(year: 2018, month: 3, amount: 0) }

    assert_equal Statement.paid.count, 3
  end

  def test_scope_by_payroll
    2.times { prepare_statement(year: 2018, month: 1) }
    3.times { prepare_statement(year: 2018, month: 2) }

    assert_equal Statement.by_payroll(2017, 1).count, 0
    assert_equal Statement.by_payroll(2018, 1).count, 2
    assert_equal Statement.by_payroll(2018, 2).count, 3
  end

  def test_scope_ordered
    5.times { prepare_statement(year: 2018, month: 1) }

    assert Statement.ordered.each_cons(2).all? do |first, second|
      first.employee_id <= second.employee_id
    end
  end

  def test_corrections
    with = prepare_corrected_statement(amount: 10)
    without = prepare_corrected_statement(amount: 0)

    assert with.corrections?
    assert with.correct_by, 10

    assert_not without.corrections?
    assert without.correct_by, 0
  end

  private

  def prepare_statement(year:, month:, amount: 100)
    create(:statement, amount: amount, year: year, month: month, payroll: build(:payroll))
  end

  def prepare_corrected_statement(amount:)
    statement = build(:statement, payroll: build(:payroll))
    if amount.positive?
      create(:correction, statement: statement, amount: amount)
    end
    statement
  end
end
