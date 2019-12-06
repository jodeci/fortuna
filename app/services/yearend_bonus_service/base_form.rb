# frozen_string_literal: true
module YearendBonusService
  class BaseForm
    include Callable

    attr_reader :yearend_bonus, :params

    def initialize(yearend_bonus, params)
      @yearend_bonus = yearend_bonus
      @params = params
    end
  end
end
