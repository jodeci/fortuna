# frozen_string_literal: true
namespace :gov do
  desc "所得稅、二代健保"
  task payment: :environment do
    unless ENV["year"] && ENV["month"]
      abort "usage: rake gov:payment year=2018 month=2"
    end

    puts "公司統一編號 #{ENV['company_tax_id']}"
    puts "勞保投保代號 #{ENV['company_labor_insurance_id']}"
    puts "健保投保代號 #{ENV['company_health_insurance_id']}"
    puts "------"

    tax_a = 0 # 薪資所得（查表）
    tax_b = 0 # 獎金+兼職所得
    tax_c = 0 # 執行專業所得

    Payroll.where(year: ENV["year"], month: ENV["month"]).map do |payroll|
      next if payroll.employee.b2b?

      if payroll.salary.professional_service?
        tax_c += IncomeTaxService::ProfessionalService.call(payroll)
      elsif payroll.salary.parttime_income_uninsured_for_labor?
        tax_b += IncomeTaxService::UninsurancedSalary.call(payroll)
      else
        tax_a += IncomeTaxService::InsurancedSalary.call(payroll)
        tax_b += IncomeTaxService::IrregularIncome.call(payroll)
      end
    end

    puts "所得稅公司代扣（151 薪資所得）: #{tax_a}"
    puts "所得稅公司代扣（151 兼職/獎金所得）: #{tax_b}"
    puts "所得稅公司代扣（156 執行專業所得）: #{tax_c}"

    premium = HealthInsuranceService::CompanyCoverage.call(ENV["year"], ENV["month"])
    puts "二代健保公司負擔(61): #{premium}"

    premium = HealthInsuranceService::CompanyWithhold.call(ENV["year"], ENV["month"], 62)
    puts "二代健保公司代扣(62): #{premium}"

    premium = HealthInsuranceService::CompanyWithhold.call(ENV["year"], ENV["month"], 65)
    puts "二代健保公司代扣(65): #{premium}"
  end
end
