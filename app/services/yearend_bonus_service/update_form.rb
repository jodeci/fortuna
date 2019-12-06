# frozen_string_literal: true
module YearendBonusService
  # TODO: rewrite as form object
  class UpdateForm < BaseForm
    def call
      params[:salary_based_bonus] = salary_based_bonus
      params[:income_tax] = income_tax
      params[:health_insurance] = health_insurance
      params[:total] = total
      params.delete(:seniority_factor) # FIXME
      yearend_bonus.update(params)
    end

    private

    # FIXME: average_salary/average_wage
    def salary_based_bonus
      (params[:average_salary].to_f * params[:multiplier].to_f * params[:seniority_factor].to_f).round
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
