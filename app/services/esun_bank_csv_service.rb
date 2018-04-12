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

  # 薪資轉帳（薪資約定帳號）
  # 玉山銀行薪資轉帳付款檔案 S03 自訂格式-符號分隔 (,)
  # 1: 收款帳號, 2: 員工姓名, 3: 入帳金額, 4: 通知方式(2), 5: Email
  # 補滿至 18 欄
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

  # TODO: 台幣轉帳（一般約定帳號）
  # 玉山銀行台幣付款檔案 T03 自訂格式-符號分隔 (,)
  # 1. 付款帳號, 2: 付款日期(YYYYMMDD), 3: 收款總行, 4: 收款帳號, 5: 收款戶名
  # 6: 付款金額, 7. 手續費負擔別(0), 8: 通知方式(2), 9: 收款通知Email
  # 補滿至 16 欄
end
