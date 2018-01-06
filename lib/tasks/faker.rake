# frozen_string_literal: true
namespace :faker do
  desc "generate fake data"
  task fulltime: :environment do
    e = Employee.create name: "Nao", start_date: "2015-05-13", type: FulltimeEmployee
    e.salaries.create base: 30000, start_date: "2015-05-13", equipment_subsidy: 800
    e.payrolls.create year: 2015, month: 5
    e.payrolls.create year: 2015, month: 6, leavetime_hours: 5
    e.payrolls.create year: 2015, month: 7, vacation_refund_hours: 10
    p = e.payrolls.create year: 2015, month: 8
    p.overtimes.create date: "2015-08-03", hours: 3, rate: "weekday"
    p.overtimes.create date: "2015-08-07", hours: 5.5, rate: "weekend"
  end
end
