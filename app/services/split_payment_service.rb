# frozen_string_literal: true
class SplitPaymentService
  attr_reader :payroll, :salary

  # TODO: 執行業務所得超過兩萬元時拆單
  def initialize(payroll, salary)
    @payroll = payroll
    @salary = salary
  end
end
