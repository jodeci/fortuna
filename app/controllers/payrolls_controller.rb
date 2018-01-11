# frozen_string_literal: true
class PayrollsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    @payroll = PayrollService.new(Payroll.find(params[:id])).run
    render_pdf filename: @payroll[:filename]
  end

  def edit
    # @payroll = Payroll.find(params[:id])
  end

  private

  def record_not_found
  end

  def render_pdf(filename: "filename", orientation: "landscape")
    respond_to do |format|
      format.html
      format.pdf do
        render(
          pdf: filename,
          encoding: "utf-8",
          layout: "pdf",
          orientation: orientation
        )
      end
    end
  end
end
