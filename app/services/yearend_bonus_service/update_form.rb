# frozen_string_literal: true
module YearendBonusService
  class UpdateForm < BaseForm
    def call
      prepare_params
      yearend_bonus.update(params)
    end
  end
end
