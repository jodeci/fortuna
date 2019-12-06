# frozen_string_literal: true
module YearendBonusService
  class UncreatedLunarYears
    include Callable

    attr_reader :employee

    def initialize(employee)
      @employee = employee
    end

    # 因為需要因應特殊狀況，不檢查年底時的在職狀態
    def call
      remove_overlapping_years
    end

    private

    def lunar_years_after_first_employment
      LunarYear.ordered.where("last_working_day >= ?", first_employed)
    end

    def first_employed
      employee.terms.ordered.last.start_date
    end

    def exisiting_yearend_bonuses
      employee.yearend_bonuses.pluck(:lunar_year_id)
    end

    def remove_overlapping_years
      lunar_years_after_first_employment.where.not(id: exisiting_yearend_bonuses)
    end
  end
end
