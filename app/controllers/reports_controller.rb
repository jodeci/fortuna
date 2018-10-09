# frozen_string_literal: true
class ReportsController < ApplicationController
  before_action :store_location, except: [:index]

  def index
    return unless params[:query]
    redirect_to action: params[:query][:income_type], year: params[:query][:year]
  end

  def salary
    @report = SalaryIncomeReportService.new(params[:year]).call
  end

  def service
    @report = ServiceIncomeReportService.new(params[:year]).call
  end

  def irregular
  end
end
