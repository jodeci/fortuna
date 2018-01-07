# frozen_string_literal: true
class PayrollsController < ApplicationController
  def show
    service = PayrollService.new(Payroll.find(params[:id]))
    @payroll = service.run

    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: "#{@payroll[:meta][:name]} #{@payroll[:meta][:period]} 薪資明細",
          encoding: "utf-8",
          layout: "pdf",
          orientation: "Landscape"
        )
      end
    end
  end

  def edit
    # @payroll = Payroll.find(params[:id])
  end
end
