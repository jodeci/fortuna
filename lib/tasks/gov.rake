# frozen_string_literal: true
namespace :gov do
  desc "所得稅、二代健保"
  task payment: :environment do
    unless ENV["year"] and ENV["month"]
      abort "usage: rake gov:payment year=2018 month=2"
    end

    puts "公司統一編號 #{ENV['company_tax_id']}"
    puts "勞保投保代號 #{ENV['company_labor_insurance_id']}"
    puts "健保投保代號 #{ENV['company_health_insurance_id']}"
    puts "------"

    employee_sum = CalculationService::TotalEmployee.call(ENV["year"], ENV["month"])
    taxable_income_sum = SalaryService::TaxableIncomeSum.call(ENV["year"], ENV["month"])
    taxable_income_tax_sum = IncomeTaxService::TaxableIncomeTaxSum.call(ENV["year"], ENV["month"])
    irregular_income_sum = SalaryService::IrregularIncomeSum.call(ENV["year"], ENV["month"])
    irregular_tax_sum = IncomeTaxService::IrregularTaxSum.call(ENV["year"], ENV["month"])

    puts "員工人數: #{employee_sum}"
    puts "每月給付之薪資給付所得總額: #{taxable_income_sum}"
    puts "每月給付之薪資給付所得稅代扣總額: #{taxable_income_tax_sum}"
    puts "非每月給付之薪資給付所得總額: #{irregular_income_sum}"
    puts "非每月給付之薪資給付所得稅代扣總額: #{irregular_tax_sum}"

    premium = HealthInsuranceService::CompanyCoverage.call(ENV["year"], ENV["month"])
    puts "二代健保公司負擔(61): #{premium}"

    premium = HealthInsuranceService::CompanyWithhold.call(ENV["year"], ENV["month"])
    puts "二代健保公司代扣(62): #{premium}"
  end
end
