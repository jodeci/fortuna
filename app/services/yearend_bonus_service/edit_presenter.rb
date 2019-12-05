# frozen_string_literal: true
module YearendBonusService
  class EditPresenter < BasePresenter
    def initialize(yearend_bonus)
      @employee = yearend_bonus.employee
      @lunar_year = yearend_bonus.lunar_year
    end
  end
end
