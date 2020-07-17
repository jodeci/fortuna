# frozen_string_literal: true
require "test_helper"

module SalaryService
  class FinderTest < ActiveSupport::TestCase
    def test_find_salary_by_employee_term
      employee = build(:employee)
      term1 = create(:term, start_date: "2015-05-13", end_date: "2016-11-15", employee: employee)
      term2 = create(:term, start_date: "2018-02-06", end_date: nil, employee: employee)
      salary1 = create(:salary, effective_date: "2015-05-13", employee: employee, term: term1)
      salary2 = create(:salary, effective_date: "2015-09-01", employee: employee, term: term1)
      salary3 = create(:salary, effective_date: "2018-02-06", employee: employee, term: term2)

      assert_nil SalaryService::Finder.call(employee, Date.new(2015, 4, 1), Date.new(2015, 4, -1))
      assert_equal salary1, SalaryService::Finder.call(employee, Date.new(2015, 5, 1), Date.new(2015, 5, -1))
      assert_equal salary2, SalaryService::Finder.call(employee, Date.new(2015, 9, 1), Date.new(2015, 9, -1))
      assert_nil SalaryService::Finder.call(employee, Date.new(2016, 12, 1), Date.new(2016, 12, -1))
      assert_equal salary3, SalaryService::Finder.call(employee, Date.new(2018, 2, 1), Date.new(2018, 2, -1))
    end
  end
end
