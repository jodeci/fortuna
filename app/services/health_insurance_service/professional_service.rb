# frozen_string_literal: true
# 二代健保：執行業務所得 單次給付超過兩萬元
module HealthInsuranceService
  class ProfessionalService < SupplementPremium
    private

    def eligible?
      taxable_income > exemption
    end

    def premium_base
      taxable_income
    end

    def exemption
      20000
    end
  end
end
