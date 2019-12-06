# frozen_string_literal: true
module IncomeTaxService
  class YearendBonus
    include Callable

    attr_reader :params

    def initialize(params)
      @params = params
    end

    # 非經常性給予超過免稅額 需代扣 5% 所得稅
    def call
      return 0 unless taxable?
      (irregular_income * rate).round
    end

    private

    def taxable?
      irregular_income > exemption
    end

    def irregular_income
      params[:salary_based_bonus] + params[:fixed_amount] + params[:cash_benefit]
    end

    def exemption
      IncomeTaxService::Exemption.call(params[:paydate].year, params[:paydate].month)
    end

    def rate
      0.05
    end
  end
end
