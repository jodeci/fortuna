# frozen_string_literal: true
class ReportsController < ApplicationController
  before_action :store_location, except: [:index]

  def index
    return unless params[:query]
    redirect_to action: params[:query][:income_type], year: params[:query][:year]
  end

  def salary
    @report = ReportService::SalaryIncome.call(params[:year])
  end

  def service
    @report = ReportService::ServiceIncome.call(params[:year])
  end

  def irregular
    @report = ReportService::IrregularIncome.call(params[:year])
  end
end
