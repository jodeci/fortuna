# frozen_string_literal: true
module SalaryService
  class Finder
    include Callable

    attr_reader :cycle_start, :cycle_end, :employee

    def initialize(employee, cycle_start, cycle_end)
      @employee = employee
      @cycle_start = cycle_start
      @cycle_end = cycle_end
    end

    def call
      return unless payroll_period_overlaps_with_term?
      employee.salaries.effective_by(cycle_end)
    end

    private

    def term
      @term ||= employee.term(cycle_start, cycle_end)
    end

    def payroll_period_overlaps_with_term?
      return false if term.blank?
      return true unless term.end_date
      return true if cycle_start <= term.end_date and cycle_end >= term.start_date
    end
  end
end
