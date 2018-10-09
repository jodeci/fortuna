# frozen_string_literal: true
class StatementSyncService
  include Callable

  attr_accessor :payroll

  def initialize(payroll)
    @payroll = payroll
  end

  def call
    StatementService.new(payroll).build
  end
end
