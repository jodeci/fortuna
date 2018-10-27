# frozen_string_literal: true
# 二代健保：兼職薪資所得 單次給付超過最低薪資
module HealthInsuranceService
  class ParttimeIncome < SupplementPremium
    private

    def eligible?
      taxable_income > exemption
    end

    def premium_base
      taxable_income
    end

    def exemption
      MinimumWageService.call(payroll.year, payroll.month)
    end
  end
end
