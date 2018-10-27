# frozen_string_literal: true
module HealthInsuranceService
  class CompanyCoverage
    include Callable

    attr_reader :year, :month

    def initialize(year, month)
      @year = year.to_i
      @month = month.to_i
    end

    def call
      (premium_base * rate).round
    end

    private

    def premium_base
      owner_income + salary_insurance_gaps
    end

    # 負責人薪資全額
    # FIXME: 負責人有變動的可能
    def owner_income
      row = PayrollDetail.owner_income(year: year, month: month)
      row.amount - row.subsidy_income
    end

    # （負責人以外）實發薪資與投保薪資的差額
    def salary_insurance_gaps
      PayrollDetail.monthly_salary(year: year, month: month).reduce(0) do |sum, row|
        sum + salary_insurance_gap(row)
      end
    end

    def salary_insurance_gap(row)
      row.amount - row.subsidy_income - row.insured_for_health
    end

    def rate
      0.0191
    end
  end
end
