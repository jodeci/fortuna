# frozen_string_literal: true
module StatementService
  class Splitter
    include Callable
    include Calculatable

    attr_reader :payroll, :salary, :array

    def initialize(payroll)
      @payroll = payroll
      @salary = payroll.salary
      @array = []
    end

    def call
      split_statement? ? splits : nil
    end

    private

    def split_statement?
      return false unless salary.split?
      paid_amount > split_base
    end

    def split_base
      if salary.parttime_income_uninsured_for_labor?
        minimum_wage
      else
        professional_service_threshold
      end
    end

    def splits
      ratio.times { array << split_interval }
      array << (paid_amount - (ratio * split_interval))
      array.delete 0
      array
    end

    def ratio
      paid_amount / split_interval
    end

    def minimum_wage
      MinimumWageService.call(payroll.year, payroll.month)
    end

    def professional_service_threshold
      20000
    end

    # 用低於最低薪資的整數拆單
    def split_interval
      20000
    end
  end
end
