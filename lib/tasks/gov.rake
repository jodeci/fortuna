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

    tax_a = 0
    tax_b = 0
    tax_c = 0
    health65 = 0

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

      if payroll.salary.professional_service? && !payroll.salary.split?
        health65 += HealthInsuranceService::ProfessionalService.call(payroll)
      end
    end

    puts "所得稅公司代扣 (151 薪資所得): #{tax_a}"
    puts "所得稅公司代扣 (151 兼職/獎金所得): #{tax_b}"
    puts "所得稅公司代扣 (156 執行專業所得): #{tax_c}"

    health61 = HealthInsuranceService::CompanyCoverage.call(ENV["year"], ENV["month"])
    puts "二代健保公司負擔(61): #{health61}"

    health62 = HealthInsuranceService::CompanyWithholdBonus.call(ENV["year"], ENV["month"])
    puts "二代健保公司代扣(62): #{health62}"

    puts "二代健保公司代扣(65): #{health65}"
  end
end
