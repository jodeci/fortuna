# frozen_string_literal: true
namespace :faker do
  desc "reset db"
  task reset: :environment do
    Rake::Task["db:drop"].execute
    Rake::Task["db:create"].execute
    Rake::Task["db:migrate"].execute
    Rake::Task["faker:regular"].execute
    Rake::Task["faker:contractor"].execute
    Rake::Task["faker:parttime"].execute
  end

  desc "generate fake data for regular employee"
  task regular: :environment do
    e = Employee.create name: "Nao", start_date: "2015-05-13", type: "RegularEmployee"
    e.salaries.create monthly_wage: 30000, start_date: "2015-05-13", labor_insurance: 637, health_insurance: 426
    e.payrolls.create year: 2015, month: 5
    e.payrolls.create year: 2015, month: 6, leavetime_hours: 5, sicktime_hours: 3
    e.payrolls.create year: 2015, month: 7, vacation_refund_hours: 10
    p = e.payrolls.create year: 2015, month: 8
    p.overtimes.create date: "2015-08-03", hours: 3, rate: "weekday"
    p.overtimes.create date: "2015-08-07", hours: 5.5, rate: "weekend"
    p.extra_entries.create title: "中秋禮金", amount: 1500
    p.extra_entries.create title: "誤餐費", amount: 240
  end

  desc "generate fake data for contractor"
  task contractor: :environment do
    e = Employee.create name: "Hidetoshi", start_date: "2016-07-12", type: "ContractorEmployee"
    e.salaries.create monthly_wage: 50000, start_date: "2016-07-12"
    e.payrolls.create year: 2016, month: 7
    e.payrolls.create year: 2016, month: 8
    p = e.payrolls.create year: 2016, month: 9, leavetime_hours: 24
    p.extra_entries.create title: "健保補收", amount: -2000, note: "2016-08 二代健保費用於本月補收"

    e = Employee.create name: "Masaharu", start_date: "2017-02-05", type: "ContractorEmployee"
    e.salaries.create monthly_wage: 50000, start_date: "2017-02-05", labor_insurance: 962, health_insurance: 712
    e.payrolls.create year: 2017, month: 3

    e = Employee.create name: "Teruyuki", start_date: "2017-02-05", type: "ContractorEmployee"
    e.salaries.create monthly_wage: 20000, start_date: "2017-02-05", tax_code: "9A"
    e.payrolls.create year: 2017, month: 3

    e = Employee.create name: "Yusuke", start_date: "2017-02-05", type: "ContractorEmployee"
    e.salaries.create monthly_wage: 120000, start_date: "2017-02-05", tax_code: "9A"
    e.payrolls.create year: 2017, month: 3
  end

  desc "generate fake date for parttime"
  task parttime: :environment do
    e = Employee.create name: "Kazunari", start_date: "2016-01-20", type: "ParttimeEmployee"
    e.salaries.create hourly_wage: 150, start_date: "2016-01-20", labor_insurance: 233, commuting_subsidy: 3000
    e.payrolls.create year: 2016, month: 1, parttime_hours: 55.5

    e = Employee.create name: "Masaki", start_date: "2016-01-20", type: "ParttimeEmployee"
    e.salaries.create hourly_wage: 150, start_date: "2016-01-20"
    e.payrolls.create year: 2016, month: 1, parttime_hours: 100
  end
end
