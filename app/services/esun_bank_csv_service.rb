# frozen_string_literal: true
require "csv"

class EsunBankCSVService
  attr_reader :statements

  def initialize(statements)
    @statements = statements
  end

  def csv_rows
    @rows = []
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
    row = []
    row.push employee.bank_account.slice(4, 13)
    row.push employee.name
    row.push amount
    row.push "2"
    row.push employee.email
    13.times { row.push nil }
    row
  end
end
