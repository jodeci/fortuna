# frozen_string_literal: true
module FormatService
  class ExtraDeductions
    include Callable

    attr_reader :payroll, :hash

    def initialize(payroll)
      @payroll = payroll
      @hash = {}
    end

    def call
      payroll.extra_entries.map { |entry| hash[entry.title] = entry.amount.abs if entry.amount.negative? }
      hash
    end
  end
end
