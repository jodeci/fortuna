# frozen_string_literal: true
class ReportsController < ApplicationController
  before_action :store_location, except: [:index]

  def index
    return unless params[:query]
    redirect_to action: params[:query][:income_type], year: params[:query][:year]
  end

  def salary
    @report = ReportService.new(params[:year], :salary).call
  end

  def service
    @report = ReportService.new(params[:year], :service).call
  end

  def irregular
    @report = ReportService.new(params[:year], :irregular).call
  end
end
