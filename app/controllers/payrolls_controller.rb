# frozen_string_literal: true
class PayrollsController < ApplicationController
  before_action :prepare, only: [:show, :edit]

  def new
  end

  def show
    @payroll = PayrollService.new(Payroll.find(params[:id])).run
    render_pdf filename: @payroll[:filename]
  end

  def edit
  end

  private

  def prepare
    @payroll = PayrollService.new(prepare_payroll).run
  end

  def prepare_payroll
    Payroll.find_by(id: params[:id]) or not_found
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
