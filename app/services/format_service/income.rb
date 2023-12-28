# frozen_string_literal: true
module FormatService
  class Income
    include Callable
    include Calculatable

    attr_reader :payroll, :salary

    def initialize(payroll)
      @payroll = payroll
      @salary = payroll.salary
    end

    def call
      cleanup send(salary.role)
    end

    private

    def boss
      {
        本薪: scale_for_cycle(base_salary),
        伙食費: scale_for_cycle(taxfree_lunch),
      }.merge(festival_bonus)
        .merge(extra_gain)
    end

    def regular
      {
        本薪: scale_for_cycle(base_salary),
        伙食費: scale_for_cycle(taxfree_lunch),
        設備津貼: equipment_subsidy,
        主管加給: supervisor_allowance,
        交通津貼: salary.commuting_subsidy,
        加班費: overtime,
        特休折現: vacation_refund,
      }.merge(festival_bonus)
        .merge(extra_gain)
    end

    def contractor
      {
        "#{salary_label}": monthly_wage,
        設備津貼: equipment_subsidy,
        加班費: overtime,
      }.merge(festival_bonus)
        .merge(extra_gain)
    end

    def vendor
      { "#{salary_label}": monthly_wage }.merge(extra_gain)
    end

    def parttime
      {
        薪資: total_wage,
        交通津貼: salary.commuting_subsidy,
      }.merge(festival_bonus)
        .merge(extra_gain)
    end

    def advisor
      { 服務費用: total_wage }.merge(extra_gain)
    end

    def salary_label
      salary.professional_service? ? "開發費" : "薪資"
    end

    def base_salary
      salary.monthly_wage - taxfree_lunch
    end

    def taxfree_lunch
      if payroll.year >= 2024
        3000
      elsif payroll.year >= 2015
        2400
      else
        1800
      end
    end

    def extra_gain
      FormatService::ExtraIncome.call(payroll)
    end

    def festival_bonus
      FormatService::FestivalBonus.call(payroll)
    end

    def cleanup(hash)
      hash.delete_if { |_, value| value.zero? }
    end
  end
end
