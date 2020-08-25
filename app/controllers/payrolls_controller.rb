# frozen_string_literal: true
class PayrollsController < ApplicationController
  before_action :prepare_payroll, only: [:edit, :update, :destroy]
  before_action :store_location, only: [:index]

  def index
    @query = Payroll.search_result.ransack(params[:query])
    @result = @query.result(distinct: true).page(params[:page])
  end

  def parttimers
    @result = SalaryTracker.on_payroll(year: year, month: month).by_role(role: %w[vendor advisor parttime])
  end

  def init_regulars
    PayrollInitRegularsService.call(year, month)
    redirect_to_date
  end

  def init_parttimers
    params[:parttimers].each do |row|
      values = row.split(",")
      PayrollInitService.call(year, month, values[0], values[1])
    end
    redirect_to_date
  end

  def edit
  end

  def update
    if @payroll.update(payroll_params)
      StatementService::Builder.call(@payroll)
      redirect_to session.delete(:return_to)
    else
      render :edit
    end
  end

  def destroy
    employee = @payroll.employee
    @payroll.destroy
    redirect_to employee_path(employee)
  end

  private

  def payroll_params
    params.require(:payroll).permit(
      :parttime_hours, :leavetime_hours, :sicktime_hours,
      :vacation_refund_hours, :festival_bonus, :festival_type,
      overtimes_attributes: [:date, :rate, :hours, :_destroy, :id],
      extra_entries_attributes: [:title, :amount, :income_type, :note, :_destroy, :id]
    )
  end

  def prepare_payroll
    (@payroll = Payroll.find_by(id: params[:id])) || not_found
  end

  def redirect_to_date
    redirect_to action: :index, query: { year_eq: year, month_eq: month }
  end

  def year
    params[:year].to_i
  end

  def month
    params[:month].to_i
  end
end
