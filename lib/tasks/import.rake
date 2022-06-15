# frozen_string_literal: true
require "csv"

namespace :import do
  desc "import csv"
  task csv: :environment do
    CSV.foreach(ENV.fetch("file"), headers: true, header_converters: :symbol) do |row|
      data = row.to_hash
      employee = {
        name: data[:name],
        id_number: data[:id_number],
        residence_address: data[:residence_address],
        birthday: data[:birthday],
        company_email: data[:company_email],
        personal_email: data[:personal_email],
        bank_account: data[:bank_account],
        bank_transfer_type: data[:bank_transfer_type],
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
        insured_for_health: data[:insured_for_health],
        insured_for_labor: data[:insured_for_labor],
        cycle: data[:cycle],
      }
      term = {
        start_date: data[:start_date],
        end_date: data[:end_date],
      }
      Employee.create(employee) do |e|
        e.salaries.new(salary)
        e.terms.new(term)
      end
    end
  end
end
