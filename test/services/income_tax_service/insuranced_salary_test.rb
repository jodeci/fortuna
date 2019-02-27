require "test_helper"

module IncomeTaxService
  class InsurancedSalaryTest
    def has_insuranced_salary_tax
      subject = prepare_subject(income_tax: 3000)
      assert_equal 3000, IncomeTaxService::InsurancedSalary.call(subject)
    end

    private
    def prepare_subject(income_tax: 0)
      build(
        :payroll,
        year: 2018,
        month: 5,
        salary: build(:salary, monthly_wage: 30000, income_tax: income_tax),
        employee: build(:employee),
      ) { |payroll| create(:extra_entry, income_type: :salary, payroll: payroll) }
    end
  end
end