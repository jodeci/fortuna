# frozen_string_literal: true
require "csv"

class EsunBankCSVService
  attr_reader :statements, :transfer_method, :payment_date

  def initialize(statements, transfer_type, payment_date)
    @statements = statements
    @transfer_method = "to_#{transfer_type}".to_sym
    @payment_date = payment_date
  end

  def csv_rows
    @rows = []
    statements.each { |statement| build_row(statement) }
    @rows.map(&:to_csv).join
  end

  private

  def build_row(statement)
    builder = EsunBankCSVRowBuilder.new(statement, payment_date)
    if statement.splits
      statement.splits.each { |amount| @rows << builder.__send__(transfer_method, amount: amount) }
    else
      @rows << builder.send(transfer_method)
    end
  end
end

class EsunBankCSVRowBuilder
  attr_reader :statement, :employee, :payment_date

  def initialize(statement, payment_date)
    @statement = statement
    @employee = statement.employee
    @payment_date = payment_date
  end

  # 薪資轉帳（薪資約定帳號）
  # 玉山銀行薪資轉帳付款檔案 S03 自訂格式-符號分隔 (,)
  # 1: 付款帳號, 2: 付款日期(YYYYMMDD)
  # 3: 收款帳號, 4: 員工姓名, 5: 入帳金額, 6: 通知方式(2), 7: Email
  # 補滿至 18 欄
  def to_salary(amount: statement.amount)
    row = []
    row.push ENV["company_bank_account"]
    row.push payment_date
    row.push employee.bank_account.slice(4, 16)
    row.push employee.name
    row.push amount
    row.push "2"
    row.push employee.email
    11.times { row.push nil }
    row
  end

  # 台幣轉帳（一般約定帳號）
  # 玉山銀行台幣付款檔案 T03 自訂格式-符號分隔 (,)
  # 1. 付款帳號, 2: 付款日期(YYYYMMDD), 3: 收款總行, 4: 收款帳號, 5: 收款戶名
  # 6: 付款金額, 7. 手續費負擔別(0), 8: 通知方式(2), 9: 收款通知Email
  # 補滿至 16 欄
  def to_ntd(amount: statement.amount)
    row = []
    row.push ENV["company_bank_account"]
    row.push payment_date
    row.push employee.bank_account.slice(0, 3)
    row.push employee.bank_account.slice(4, 16)
    row.push employee.name
    row.push amount
    row.push "0"
    row.push "2"
    row.push employee.email
    7.times { row.push nil }
    row
  end
end
