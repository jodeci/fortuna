# frozen_string_literal: true
require "test_helper"

class SalaryTest < ActiveSupport::TestCase
  def test_scope_recent_for
    employee = create(:employee)
    create(:salary, effective_date: "2018-01-01", employee: employee, term: build(:term))
    create(:salary, effective_date: "2018-03-01", employee: employee, term: build(:term))
    assert_equal Date.new(2018, 3, 1), Salary.recent_for(employee).effective_date
  end

  def test_adjusted_monthly_wage_for_regular_employee
    fulltime = build(:salary, monthly_wage: 30000, equipment_subsidy: 800)
    parttime = build(:salary, monthly_wage: 30000, equipment_subsidy: 800, monthly_wage_adjustment: 0.6)

    assert_equal 30800, fulltime.income_with_subsidies
    assert_equal 50800, parttime.income_with_subsidies
  end

  def test_regular_income
    assert regular.regular_income?
    assert_not intern.regular_income?
    assert_not contractor.regular_income?
    assert_not advisor.regular_income?
  end

  def test_parttime_income_uninsured_for_labor
    assert_not regular.parttime_income_uninsured_for_labor?
    assert_not intern.parttime_income_uninsured_for_labor?
    assert contractor.parttime_income_uninsured_for_labor?
    assert_not advisor.parttime_income_uninsured_for_labor?
  end

  def test_parttime_income_uninsured_for_health
    assert_not regular.parttime_income_uninsured_for_health?
    assert intern.parttime_income_uninsured_for_health?
    assert contractor.parttime_income_uninsured_for_health?
    assert_not advisor.parttime_income_uninsured_for_health?
  end

  def test_professional_service
    assert_not regular.professional_service?
    assert_not intern.professional_service?
    assert_not contractor.professional_service?
    assert advisor.professional_service?
  end

  def test_business_calendar
    normal = build(:salary, cycle: "normal")
    business = build(:salary, cycle: "business")

    assert business.business_calendar?
    assert_not normal.business_calendar?
  end

  def test_partner
    normal = build(:salary, role: "regular")
    vendor = build(:salary, role: "vendor")
    advisor = build(:salary, role: "advisor")

    assert vendor.partner?
    assert advisor.partner?
    assert_not normal.partner?
  end

  private

  def regular
    @regular ||= build(:salary, tax_code: 50, insured_for_labor: 45800, insured_for_health: 45800)
  end

  def intern
    @intern ||= build(:salary, tax_code: 50, insured_for_labor: 11100, insured_for_health: 0)
  end

  def contractor
    @contractor ||= build(:salary, tax_code: 50, insured_for_labor: 0, insured_for_health: 0)
  end

  def advisor
    @advisor ||= build(:salary, tax_code: "9a", insured_for_labor: 0, insured_for_health: 0)
  end
end
