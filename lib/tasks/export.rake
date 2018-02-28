# frozen_string_literal: true
require "csv"

# 依玉山銀行薪EASY自訂格式設計
namespace :export do
  desc "export statement to csv for bank transfer"
  task bank: :environment do
    unless ENV["year"] and ENV["month"] and ENV["path"]
      abort "usage: rake export:bank year=2018 month=2 path=tmp"
    end

    statements = Statement.by_payroll(ENV["year"], ENV["month"]).group_by do |statement|
      statement.payroll.salary.role
    end

    statements["contractor"].concat statements["parttime"]
    statements.delete "parttime"

    statements.each do |role, statements|
      builder = EsunBankCSVBuilder.new(statements)
      File.write(
        "#{ENV['path']}/#{ENV['year']}#{sprintf('%02d', ENV['month'])}_#{role}.csv",
        builder.csv_rows,
        encoding: "big5"
      )
    end
  end
end

class EsunBankCSVBuilder
  attr_reader :statements

  def initialize(statements)
    @statements = statements
  end

  def csv_rows
    @rows = Array.new
    statements.each { |statement| build_row(statement) }
    @rows.map(&:to_csv).join
  end

  private

  def build_row(statement)
    builder = EsunBankCSVRowBuilder.new(statement)
    if statement.splits
      statement.splits.each { |amount| @rows << builder.to_row(amount: amount) }
    else
      @rows << builder.to_row
    end
  end
end

class EsunBankCSVRowBuilder
  attr_reader :statement, :employee

  def initialize(statement)
    @statement = statement
    @employee = statement.employee
  end

  def to_row(amount: statement.amount)
    row = Array.new
    row.push employee.bank_account.slice(4, 13)
    row.push employee.name
    row.push amount
    row.push "2"
    row.push employee.email
    13.times { row.push nil }
    row
  end
end
