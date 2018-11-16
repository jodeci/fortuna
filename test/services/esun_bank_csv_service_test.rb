# frozen_string_literal: true
require "test_helper"
require "csv"

class EsunBankCSVServiceTest < ActiveSupport::TestCase
  def test_csv_salary
    statements = prepare_statements(bank_transfer_type: "salary")
    csv = EsunBankCSVService.call(statements, "salary", "20180705")
    subject = CSV.parse(csv).map(&:to_a).first
    assert_equal 18, subject.size
    assert_equal "20180705", subject[1]
    assert_equal "1234567890123", subject[2]
    assert_equal "John Smith", subject[3]
    assert_equal "50000", subject[4]
    assert_equal "2", subject[5]
    assert_equal "john@test.com", subject[6]
  end

  def test_csv_normal
    statements = prepare_statements(bank_transfer_type: "normal")
    csv = EsunBankCSVService.call(statements, "normal", "20180705")
    subject = CSV.parse(csv).map(&:to_a).first
    assert_equal 16, subject.size
    assert_equal "20180705", subject[1]
    assert_equal "000", subject[2]
    assert_equal "1234567890123", subject[3]
    assert_equal "John Smith", subject[4]
    assert_equal "50000", subject[5]
    assert_equal "0", subject[6]
    assert_equal "2", subject[7]
    assert_equal "john@test.com", subject[8]
  end

  def test_csv_split
    statements = prepare_statements(bank_transfer_type: "normal", splits: [30000, 20000])
    csv = EsunBankCSVService.call(statements, "normal", "20180705")
    subject = CSV.parse(csv).reduce([]) { |array, row| array << row }
    assert_equal "30000", subject[0][5]
    assert_equal "20000", subject[1][5]
  end

  def test_csv_atm
    statements = prepare_statements(bank_transfer_type: "atm")
    csv = EsunBankCSVService.call(statements, "atm", "20180705")
    subject = CSV.parse(csv).map(&:to_a).first
    assert_equal 4, subject.size
    assert_equal "000", subject[0]
    assert_equal "1234567890123", subject[1]
    assert_equal "John Smith", subject[2]
    assert_equal "50000", subject[3]
  end

  private

  def prepare_statements(bank_transfer_type:, splits: nil)
    employee = build(
      :employee,
      name: "John Smith",
      company_email: "john@test.com",
      personal_email: "john@test.com",
      bank_transfer_type: bank_transfer_type,
      bank_account: "000-1234567890123"
    )

    build(
      :payroll,
      salary: build(:salary, employee: employee),
      employee: employee
    ) { |payroll| create(:statement, payroll: payroll, amount: 50000, splits: splits) }

    Statement.all
  end
end
