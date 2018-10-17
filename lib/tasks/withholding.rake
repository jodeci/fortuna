# frozen_string_literal: true

namespace :withholding do
  desc "income tax"
  task tax: :environment do
    unless ENV["year"] and ENV["month"]
      abort "usage: rake tax:tax year=2018 month=2"
    end

    sum = 0
    Payroll.where(year: ENV["year"], month: ENV["month"]).map do |payroll|
      next if payroll.statement.splits?
      tax = IncomeTaxService::Dispatcher.call(payroll)
      sum += tax if tax.positive?
    end

    puts "#{ENV['year']}-#{sprintf('%02d', ENV['month'])} 所得稅代扣: #{sum}"
  end
end
