# frozen_string_literal: true
class ExtraEntriesService
  attr_reader :payroll, :hash

  def initialize(payroll)
    @payroll = payroll
    @hash = {}
  end

  def gain
    payroll.extra_entries.map { |entry| hash[entry.title] = entry.amount if entry.amount.positive? }
    hash
  end

  def loss
    payroll.extra_entries.map { |entry| hash[entry.title] = entry.amount.abs if entry.amount.negative? }
    hash
  end
end
