# frozen_string_literal: true
class StatementsController < ApplicationController
  before_action :prepare_statement, only: [:show, :edit, :update]
  before_action :prepare_details, only: [:show, :edit]

  def index
    @query = Statement.paid.ordered.ransack(params[:query])
    @statements = @query.result(distinct: true).page(params[:page])
  end

  def show
    render_statement
  end

  def edit
  end

  def update
    if StatementService::Update.call(@statement, statement_params)
      redirect_to session.delete(:return_to)
    else
      render :edit
    end
  end

  private

  def prepare_statement
    (@statement = Statement.find_by(id: params[:id])) || not_found
  end

  def prepare_details
    @details = FormatService::StatementDetails.call(@statement)
  end

  def statement_params
    params.require(:statement).permit(
      corrections_attributes: [:description, :amount, :_destroy, :id]
    )
  end

  def render_statement
    respond_to do |format|
      format.html { render @details[:template] }
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
