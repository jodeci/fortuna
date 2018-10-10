# frozen_string_literal: true
class ReportsController < ApplicationController
  before_action :store_location, except: [:index]

  def index
    return unless params[:query]
    redirect_to action: params[:query][:income_type], year: params[:query][:year]
  end

  def salary
    @report = SalaryIncomeReportService.call(params[:year])
  end

  def service
    @report = ServiceIncomeReportService.call(params[:year])
  end

  def irregular
    @report = IrregularIncomeReportService.call(params[:year])
  end
end
