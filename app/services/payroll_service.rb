# frozen_string_literal: true
class PayrollService
  attr_reader :payroll

  def initialize(payroll)
    @payroll = payroll
  end

  def run
    "#{payroll.employee.type}PayrollService".constantize.new(payroll).run
  end
end
