# frozen_string_literal: true
namespace :gov do
  desc "所得稅、二代健保"
  task payment: :environment do
    unless ENV.fetch("year") && ENV.fetch("month")
      abort "usage: rake gov:payment year=2018 month=2"
    end

    puts "公司統一編號 #{ENV.fetch('company_tax_id')}"
    puts "勞保投保代號 #{ENV.fetch('company_labor_insurance_id')}"
    puts "健保投保代號 #{ENV.fetch('company_health_insurance_id')}"
    puts "------"

    tax_a = 0
    tax_b = 0
    tax_c = 0
    health63 = 0
    health65 = 0

    Payroll.where(year: ENV.fetch("year"), month: ENV.fetch("month")).map do |payroll|
      next if payroll.employee.b2b?

      if payroll.salary.regular_income?
        tax_a += IncomeTaxService::InsurancedSalary.call(payroll)
        tax_b += IncomeTaxService::IrregularIncome.call(payroll)
      elsif payroll.salary.professional_service?
        tax_c += IncomeTaxService::ProfessionalService.call(payroll)
        health65 += HealthInsuranceService::ProfessionalService.call(payroll) unless payroll.salary.split?
      else
        next if payroll.salary.split?
        tax_b += IncomeTaxService::UninsurancedSalary.call(payroll) if payroll.salary.parttime_income_uninsured_for_labor?
        health63 += HealthInsuranceService::ParttimeIncome.call(payroll) if payroll.salary.parttime_income_uninsured_for_health?
      end
    end

    puts "所得稅公司代扣 (151 薪資所得): #{tax_a}"
    puts "所得稅公司代扣 (151 兼職/獎金所得): #{tax_b}"
    puts "所得稅公司代扣 (156 執行專業所得): #{tax_c}"

    health61 = HealthInsuranceService::CompanyCoverage.call(ENV.fetch("year"), ENV.fetch("month"))
    puts "二代健保公司負擔(61): #{health61}"

    health62 = HealthInsuranceService::CompanyWithholdBonus.call(ENV.fetch("year"), ENV.fetch("month"))
    puts "二代健保公司代扣(62): #{health62}"

    puts "二代健保公司代扣(63): #{health63}"
    puts "二代健保公司代扣(65): #{health65}"
  end
end
