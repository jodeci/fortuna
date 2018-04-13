# frozen_string_literal: true
class StatementsController < ApplicationController
  def index
    @q = Statement.ransack(params[:q])
    @statements = @q.result(distinct: true)
      .order(id: :desc)
      .includes(:payroll, payroll: :employee)
      .page(params[:page])
  end

  def show
    statement = Statement.find_by(id: params[:id]) or not_found
    @details = StatementDetailsService.new(statement).run
    render_statement
  end

  private

  def render_statement
    respond_to do |format|
      format.html { render template: @details[:template] }
      format.pdf { render_statement_pdf }
    end
  end

  def render_statement_pdf
    render(
      template: @details[:template],
      pdf: @details[:filename],
      encoding: "utf-8",
      layout: "pdf",
      orientation: "landscape"
    )
  end
end
