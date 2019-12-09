# frozen_string_literal: true
module YearendBonusService
  class CreateForm < BaseForm
    def call
      prepare_params
      YearendBonus.create(params)
    end
  end
end
