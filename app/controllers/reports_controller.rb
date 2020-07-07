# frozen_string_literal: true
require "csv"
class ReportsController < ApplicationController
  before_action :store_location, except: [:index]

  def index
    return unless report_type && year
    redirect_to action: report_type, year: year
  end

  def salary
    @report = ReportService::SalaryIncome.call(year)
    render_report
  end

  def service
    @report = ReportService::ServiceIncome.call(year)
    render_report
  end

  def irregular
    @report = ReportService::IrregularIncome.call(year)
    render_report
  end

  def monthly
    @report = ReportService::MonthlyStatements.call(year, month)
    render_report
  end

  private

  def report_type
    params[:report_type]
  end

  def year
    params[:year]
  end

  def month
    params[:month]
  end

  def render_report
    respond_to do |format|
      format.html
      format.csv { send_data(generate_csv_data, filename: filename) }
    end
  end

  def generate_csv_data
    data_table.css("tr").map do |row|
      row.css("td, th").map(&:text).to_csv
    end.join.encode("utf-8", undef: :replace, replace: "")
  end

  def data_table
    template ||= "reports/#{action_name}.haml"
    content = render_to_string(template)
    Nokogiri::HTML(content).at_css("table")
  end

  def filename
    if month
      "#{params[:year]}_#{sprintf('%02d', params[:month])}_#{t(action_name, scope: :reports)}.csv"
    else
      "#{params[:year]}_#{t(action_name, scope: :reports)}.csv"
    end
  end
end
