# frozen_string_literal: true
class ExtraEntriesService
  attr_reader :payroll
  attr_accessor :hash

  def initialize(payroll)
    @payroll = payroll
    @hash = {}
  end

  def gain
    payroll.extra_entries.map { |i| hash[i.title] = i.amount if i.amount > 0 }
    hash
  end

  def loss
    payroll.extra_entries.map { |i| hash[i.title] = i.amount.abs if i.amount < 0 }
    hash
  end
end
