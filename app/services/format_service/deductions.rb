# frozen_string_literal: true
module FormatService
  class Deductions
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
        勞保費: labor_insurance,
        健保費: health_insurance,
        所得稅: income_tax,
      }.merge(extra_loss)
    end

    def regular
      {
        勞保費: labor_insurance,
        健保費: health_insurance,
        二代健保: supplement_premium,
        所得稅: income_tax,
        請假扣薪: leavetime + sicktime,
      }.merge(extra_loss)
    end

    def contractor
      {
        勞保費: labor_insurance,
        健保費: health_insurance,
        二代健保: supplement_premium,
        所得稅: income_tax,
        請假扣薪: leavetime,
      }.merge(extra_loss)
    end

    def vendor
      contractor
    end

    def parttime
      {
        勞保費: labor_insurance,
        健保費: health_insurance,
        二代健保: supplement_premium,
        所得稅: income_tax,
      }.merge(extra_loss)
    end

    def advisor
      {
        二代健保: supplement_premium,
        所得稅: income_tax,
      }.merge(extra_loss)
    end

    def health_insurance
      salary.health_insurance
    end

    def extra_loss
      FormatService::ExtraDeductions.call(payroll)
    end

    def cleanup(hash)
      hash.delete_if { |_, value| value.zero? }
    end
  end
end
