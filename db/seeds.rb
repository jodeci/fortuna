# Create Regular
#

DEFAULT_EMP_AMT = (ENV['DEFAULT_EMP_AMT'] || 10).to_i
MONTH_SALARIES = [50000, 80000, 40000]

regular_employees = DEFAULT_EMP_AMT.times.map do |i|
  FactoryBot.create(:employee_with_payrolls, month_salary: MONTH_SALARIES.sample)
end

p4r = Payroll.where(employee_id: regular_employees.map(&:id))

p4r.select{|p| p.month == 9}.each{|p| p.extra_entries.create title: "中秋禮金", amount: 1500, income_type: "bonus" }
p4r.sample(5).each{|p| p.extra_entries.create title: "誤餐費", amount: 240, income_type: "subsidy" }
p4r.sample(4).each do |p|
  d = Date.new(p.year,p.month,1)
  ed = d.end_of_month
  dd = (d..ed).to_a.sample
  hours = (2..6).to_a.sample
  rate = dd.on_weekday? ? "weekday" : "weekend"
  p.overtimes.create date: dd, hours: hours, rate: rate
end

contractors = DEFAULT_EMP_AMT.times.map do |i|
  FactoryBot.create :employee_with_payrolls, month_salary: MONTH_SALARIES.sample, role: "contractor"
end

arubaitos = DEFAULT_EMP_AMT.times.map do |i|
  FactoryBot.create :parttime_employee_with_payrolls, hour_salary: 200
end
