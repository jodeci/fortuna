# frozen_string_literal: true
require "test_helper"
module SalaryService
  class IrregularIncomeTest < ActiveSupport::TestCase
  def test_irregular_income
    subject = prepare_subject
    assert_equal 100, SalaryService::IrregularIncome.call(subject)
  end

  private

  def prepare_subject
    employee = create(:employee)
    create(
      :payroll, 
      festival_bonus: 100,
      salary: create(:salary, employee: employee), 
      employee: employee
    )
    end
  end
end