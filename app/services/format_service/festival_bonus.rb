# frozen_string_literal: true
module FormatService
  class FestivalBonus
    include Callable

    attr_reader :payroll, :hash

    def initialize(payroll)
      @payroll = payroll
      @hash = {}
    end

    def call
      if payroll.festival_bonus.positive?
        hash[title] = payroll.festival_bonus
      end
      hash
    end

    private

    def title
      Payroll::FESTIVAL_BONUS.key(payroll.festival_type)
    end
  end
end
