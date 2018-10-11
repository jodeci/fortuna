# frozen_string_literal: true
class ExtraIncomeService
  include Callable

  attr_reader :payroll, :hash

  def initialize(payroll)
    @payroll = payroll
    @hash = {}
  end

  def call
    payroll.extra_entries.map { |entry| hash[entry.title] = entry.amount if entry.amount.positive? }
    hash
  end
end
