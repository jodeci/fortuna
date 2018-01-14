# frozen_string_literal: true
class PayrollsController < ApplicationController
  before_action :prepare_payroll, only: [:show, :edit, :update]

  def index
    @payrolls = Payroll.all
  end

  def index_by_date
    @payrolls = Payroll.by_date(params[:year], params[:month])
    render :index
  end

  def new
  end

  def create
  end

  def show
    @statement = StatementService.new(@payroll).run
    render_pdf filename: @statement[:filename]
  end

  def edit
  end

  def update
    if @payroll.update_attributes(payroll_params)
      redirect_to action: :index_by_date, year: @payroll.year, month: @payroll.month
    else
      render :edit
    end
  end

  def destroy
  end

  private

  def payroll_params
    params.require(:payroll).permit(
      :parttime_hours, :leavetime_hours, :sicktime_hours, :vacation_refund_hours,
      overtimes_attributes: [:date, :rate, :hours],
      extra_entries_attributes: [:title, :amount, :taxable, :note]
    )
  end

  def prepare_payroll
    @payroll = Payroll.find_by(id: params[:id]) or not_found
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
