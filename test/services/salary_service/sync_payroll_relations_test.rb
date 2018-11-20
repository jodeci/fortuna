# frozen_string_literal: true
require "test_helper"

module SalaryService
  class SyncPayrollRelationsTest < ActiveSupport::TestCase
    def test_different_salary
      employee = build(:employee)
      old_salary = build(:salary, effective_date: "2017-01-01", employee: employee)
      new_salary = build(:salary, effective_date: "2018-03-01", employee: employee)
      payroll = build(:payroll, year: 2018, month: 3, salary: old_salary, employee: employee)

      SalaryService::Finder.any_instance.expects(:call).returns(new_salary)
      SalaryService::SyncPayrollRelations.call(payroll)

      assert_equal new_salary, payroll.salary
    end

    def test_same_salary
      employee = build(:employee)
      old_salary = build(:salary, effective_date: "2017-01-01", employee: employee)
      payroll = build(:payroll, year: 2018, month: 3, salary: old_salary, employee: employee)

      SalaryService::Finder.any_instance.expects(:call).returns(old_salary)
      SalaryService::SyncPayrollRelations.call(payroll)

      assert_equal old_salary, payroll.salary
    end
  end
end
