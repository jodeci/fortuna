# frozen_string_literal: true
class PayrollsController < ApplicationController
  before_action :prepare_payroll, only: [:show, :edit, :update, :destroy]

  def index
    @q = Payroll.ransack(params[:q])
    @payrolls = @q.result(distinct: true).order(year: :desc, month: :desc)
  end

  def init
    PayrollsInitService.new(params[:year].to_i, params[:month].to_i).run
    redirect_to_date(params[:year], params[:month])
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
    if @payroll.update_attributes(payroll_params)
      StatementService.new(@payroll).sync
      redirect_to_date(@payroll.year, @payroll.month)
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

  def redirect_to_date(year, month)
    redirect_to action: :index, q: { year_eq: year, month_eq: month }
  end
end
