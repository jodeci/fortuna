# frozen_string_literal: true
module YearendBonusService
  class BaseForm
    include Callable

    attr_reader :yearend_bonus, :params

    def initialize(yearend_bonus, params)
      @yearend_bonus = yearend_bonus
      @params = params
    end

    private

    def prepare_params
      params[:salary_based_bonus] = salary_based_bonus
      params[:income_tax] = income_tax
      params[:health_insurance] = health_insurance
      params[:total] = total
    end

    def salary_based_bonus
      (params[:average_wage].to_f * params[:multiplier].to_f * params[:seniority_factor].to_f).round
    end

    def total
      salary_based_bonus + params[:fixed_amount].to_i + params[:cash_benefit].to_i - withholdings
    end

    def withholdings
      income_tax + health_insurance
    end

    # TODO
    def income_tax
      10
    end

    # TODO
    def health_insurance
      10
    end
  end
end
