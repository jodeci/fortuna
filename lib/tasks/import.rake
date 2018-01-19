# frozen_string_literal: true
require "csv"

namespace :import do
  desc "import csv"
  task csv: :environment do
    CSV.foreach(ENV["file"], headers: true, header_converters: :symbol) do |row|
      data = row.to_hash
      employee = {
        name: data[:name],
        start_date: data[:start_date],
        id_number: data[:id_number],
        residence_address: data[:residence_address],
        birthday: data[:birthday],
        company_email: data[:company_email],
        personal_email: data[:personal_email],
        bank_acount: data[:bank_account],
      }
      salary = {
        role: data[:role],
        tax_code: data[:tax_code],
        effective_date: data[:effective_date],
        monthly_wage: data[:monthly_wage],
        hourly_wage: data[:hourly_wage],
        equipment_subsidy: data[:equipment_subsidy],
        commuting_subsidy: data[:commuting_subsidy],
        supervisor_allowance: data[:supervisor_allowance],
        health_insurance: data[:health_insurance],
        labor_insurance: data[:labor_insurance],
      }
      Employee.create(employee).salaries.create(salary)
    end
  end
end
