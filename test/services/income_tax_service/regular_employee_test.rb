require "test_helper"

module IncomeTaxService
  class RegularEmployeeTest < ActiveSupport::TestCase

    def test_has_insuranced_salary_and_irregular_income
      subject = prepare_subject(festival_bonus: 10000, extra_amount: 100000, income_tax: 3000)
      IncomeTaxService::InsurancedSalary.expects(:call).returns(3000)
      IncomeTaxService::IrregularIncome.expects(:call).returns(5500)
      assert IncomeTaxService::RegularEmployee.call(subject)
    end

    private
    def prepare_subject(festival_bonus: 0, extra_amount: 0, income_tax: 0)
      build(
        :payroll,
        year: 2018,
        month: 5,
        festival_bonus: festival_bonus,
        salary: build(:salary, monthly_wage: 30000, fixed_income_tax: income_tax),
        employee: build(:employee),
      ) { |payroll| create(:extra_entry, income_type: :salary, amount: extra_amount, payroll: payroll) }
    end
  end
end  