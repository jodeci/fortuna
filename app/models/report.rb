# frozen_string_literal: true
class Report < ApplicationRecord
  INCOME_TYPE = { "薪資+三節獎金": "salary", "勞務報酬": "service", "非經常性給予": "irregular" }.freeze

  class << self
    def years
      Report.distinct.pluck(:year)
    end

    def salary_income(year)
      Report.where(tax_code: "50", year: year)
    end

    # 勞務報酬的會計月份是以「發放日期」計算，因隔月發薪，報表需要往前移一個月
    def service_income(year)
      Report
        .where("tax_code = '9a' AND year = ? AND month = 12", year - 1)
        .or(where("tax_code = '9a' AND year = ? AND month < 12", year))
    end

    def ordered
      Report.order(employee_id: :asc, year: :asc, month: :asc)
    end

    def sum_by_festival(year, festival)
      Report
        .salary_income(year)
        .where(festival_type: festival)
        .sum(:festival_bonus)
        .to_i
    end

    def sum_by_employee_salary(year:, employee_id:)
      Report
        .salary_income(year)
        .where(employee_id: employee_id)
        .sum_amount
    end

    def sum_by_employee_service(year:, employee_id:)
      Report
        .service_income(year)
        .where(employee_id: employee_id)
        .sum_amount
    end

    def sum_by_month(year:, month:, tax_code:)
      Report
        .where(tax_code: tax_code, year: year, month: month)
        .sum_amount
    end

    def sum_amount
      Report
        .pluck(Arel.sql("SUM(amount), SUM(correction), SUM(subsidy_income) * -1"))
        .flatten
        .reduce(0) { |sum, column| sum + column.to_i }
    end
  end

  def adjusted_amount
    amount - subsidy_income - festival_bonus + correction.to_i
  end
end
