# frozen_string_literal: true
class PayrollsController < ApplicationController
  before_action :prepare_payroll, only: [:show, :edit, :update, :destroy, :statement]

  def index
    @q = Payroll.ransack(params[:q])
    @payrolls = @q.result(distinct: true).order(year: :desc, month: :desc)
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
      create_or_update_statement
      redirect_to action: :index, q: { year_eq: @payroll.year, month_eq: @payroll.month }
    else
      render :edit
    end
  end

  def destroy
  end

  def statement
    @statement = StatementService.new(@payroll).run
    render_pdf filename: @statement[:filename]
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

  def create_or_update_statement
    statement = Statement.find_or_initialize_by(payroll_id: @payroll.id)
    service = StatementService.new(@payroll).run
    statement.amount = service[:total]
    statement.save
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
