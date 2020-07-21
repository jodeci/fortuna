# frozen_string_literal: true
require "test_helper"

class StatementTest < ActiveSupport::TestCase
  def test_scope_paid
    3.times { prepare_statement(year: 2018, month: 1, amount: 100) }
    2.times { prepare_statement(year: 2018, month: 3, amount: 0) }

    assert_equal 3, Statement.paid.count
  end

  def test_scope_by_payroll
    2.times { prepare_statement(year: 2018, month: 1) }
    3.times { prepare_statement(year: 2018, month: 2) }

    assert_equal 0, Statement.by_payroll(2017, 1).count
    assert_equal 2, Statement.by_payroll(2018, 1).count
    assert_equal 3, Statement.by_payroll(2018, 2).count
  end

  def test_scope_ordered
    5.times { prepare_statement(year: 2018, month: 1) }

    assert Statement.ordered.each_cons(2).all? do |first, second|
      first.employee_id <= second.employee_id
    end
  end

  private

  def prepare_statement(year:, month:, amount: 100)
    create(:statement, amount: amount, year: year, month: month, payroll: build(:payroll))
  end
end
