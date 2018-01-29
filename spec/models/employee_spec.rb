require 'rails_helper'

RSpec.describe Employee, type: :model do

  context "Regular" do

    let :month_salary do
      50000
    end

    let :emp do
      FactoryBot.create :employee_with_payrolls, month_salary: month_salary, build_statement_immediatedly: false
    end

    let :months_until_now do
      TimeDifference.between(emp.start_date, Date.today).in_months.round
    end

    it "has least one salary record" do
      expect(emp.salaries.length).to be > 0
    end

    it "has payrolls until next month" do
      expect(emp.payrolls.length).to eq(months_until_now)
    end

    it "has all payrolls with same salary" do
      expect(emp.payrolls.map(&:salary).size).to eq(emp.payrolls.length)
    end

    it "has same amount between payrolls and statements" do
      emp.payrolls.each{|payroll| StatementService.new(payroll).build  }
      expect(emp.payrolls.length).to eq(emp.statements.length)
    end

  end
end
