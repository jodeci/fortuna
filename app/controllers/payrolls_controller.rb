# frozen_string_literal: true
class PayrollsController < ApplicationController
  def show
    service = PayrollService.new(Payroll.find(params[:id]))
    @payroll = service.run
  end

  def edit
    # @payroll = Payroll.find(params[:id])
  end
end
