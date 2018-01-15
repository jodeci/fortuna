# frozen_string_literal: true
class StatementsController < ApplicationController
  def index
    @q = Statement.ransack(params[:q])
    @statements = @q.result(distinct: true)
      .order(year: :desc, month: :desc)
      .includes(:payroll, payroll: :employee)
  end

  def show
    statement = Statement.find_by(id: params[:id]) or not_found
    @details = StatementService.new(statement.payroll).run
    render_pdf filename: @details[:filename]
  end

  private

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
