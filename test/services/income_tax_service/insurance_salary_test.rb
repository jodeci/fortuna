require "test_helper"

module IncomeTaxService
  class InsuranceSalaryTest < ActiveSupport::TestCase
    def test_has_salary_tax  
      subject = prepare_subject(festival_bonus: 0, extra_amount: 0, income_tax: 3000)
      assert_equal 3000, IncomeTaxService::InsuranceSalary.call(subject, "salary")
    end

    def test_has_salary_and_bonus_tax
      subject = prepare_subject(festival_bonus: 10000, extra_amount: 100000, income_tax: 3000)
      assert_equal 8500, IncomeTaxService::InsuranceSalary.call(subject, "both")
    end

    private
    def prepare_subject(festival_bonus: 0, extra_amount: 0, income_tax: 0)
      build(
        :payroll,
        year: 2018,
        month: 5,
        festival_bonus: festival_bonus,
        salary: build(:salary, monthly_wage: 30000, income_tax: income_tax),
        employee: build(:employee),
      ) { |payroll| create(:extra_entry, income_type: :salary, amount: extra_amount, payroll: payroll) }
    end
  end
end  