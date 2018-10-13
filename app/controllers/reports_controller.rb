# frozen_string_literal: true
require "csv"
class ReportsController < ApplicationController
  before_action :store_location, except: [:index]

  def index
    return unless params[:query]
    redirect_to action: params[:query][:income_type], year: params[:query][:year]
  end

  def salary
    @report = ReportService::SalaryIncome.call(params[:year])
    render_report
  end

  def service
    @report = ReportService::ServiceIncome.call(params[:year])
    render_report
  end

  def irregular
    @report = ReportService::IrregularIncome.call(params[:year])
    render_report
  end

  private

  def render_report
    respond_to do |format|
      format.html
      format.csv { send_data(generate_csv_data, filename: filename) }
    end
  end

  def generate_csv_data
    template ||= "reports/#{action_name}.haml"
    content = render_to_string(template)
    doc = Nokogiri::HTML(content)

    table = doc.at_css("table")
    table.css("tr").map do |row|
      row.css("td, th").map(&:text).to_csv
    end.join
  end

  def filename
    "#{action_name}_#{params[:year]}.csv"
  end
end
