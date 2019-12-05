# frozen_string_literal: true
module YearendBonusService
  class NewPresenter < BasePresenter
    def initialize(employee, lunar_year)
      @employee = employee
      @lunar_year = lunar_year
    end
  end
end
