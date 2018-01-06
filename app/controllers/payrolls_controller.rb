# frozen_string_literal: true
class PayrollsController < ApplicationController
  def show
    # payroll = Payroll.find(params[:id])
    # @employee = @payroll.employee
    # @salary = @employee.recent_salary

    service = ::PayrollService.new(Payroll.find(params[:id]))
    @payroll = service.run
  end

  def edit
    # @payroll = Payroll.find(params[:id])
  end
end
