# frozen_string_literal: true
require "test_helper"

module YearendBonusService
  class AverageWageTest < ActiveSupport::TestCase
    def test_before_hire
      assert_equal 0, prepare_subject(Date.new(2018, 2, 1))
    end

    def test_parttime
      assert_equal 0, prepare_subject(Date.new(2018, 5, -1))
    end

    def test_contractor
      assert_equal 0, prepare_subject(Date.new(2018, 10, -1))
    end

    def test_regular1
      assert_equal 40000, prepare_subject(Date.new(2019, 6, -1))
    end

    def test_absent
      assert_equal 0, prepare_subject(Date.new(2019, 9, -1))
    end

    def test_regular2
      assert_equal 52500, prepare_subject(Date.new(2020, 4, -1))
    end

    private

    def prepare_subject(cycle_end)
      YearendBonusService::AverageWage.call(profile_employee, cycle_end)
    end

    def profile_employee
      build(:employee) do |employee|
        create(:term, start_date: "2018-03-01", end_date: "2019-06-30", employee: employee)
        create(:salary, effective_date: "2018-03-01", employee: employee, role: "parttime", monthly_wage: 0)
        create(:salary, effective_date: "2018-06-01", employee: employee, role: "contractor", monthly_wage: 30000)
        create(:salary, effective_date: "2018-11-01", employee: employee, role: "regular", monthly_wage: 40000)
        # absent term: 2019-07-01 ~ 2019-09-30
        create(:term, start_date: "2019-10-01", end_date: nil, employee: employee)
        create(:salary, effective_date: "2019-10-01", employee: employee, role: "regular", monthly_wage: 50000)
        create(:salary, effective_date: "2020-02-01", employee: employee, role: "regular", monthly_wage: 55000)
      end
    end
  end
end
