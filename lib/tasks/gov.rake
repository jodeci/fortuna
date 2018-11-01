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

    sum = 0
    Payroll.where(year: ENV["year"], month: ENV["month"]).map do |payroll|
      next if payroll.statement.splits?
      tax = IncomeTaxService::Dispatcher.call(payroll)
      sum += tax if tax.positive?
    end
    puts "所得稅公司代扣: #{sum}"

    premium = HealthInsuranceService::CompanyCoverage.call(ENV["year"], ENV["month"])
    puts "二代健保公司負擔(61): #{premium}"

    premium = HealthInsuranceService::CompanyWithhold.call(ENV["year"], ENV["month"])
    puts "二代健保公司代扣(62): #{premium}"
  end
end
