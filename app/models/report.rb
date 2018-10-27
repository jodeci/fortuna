# frozen_string_literal: true
class Report < ApplicationRecord
  INCOME_TYPE = { "薪資+三節獎金": "salary", "勞務報酬": "service", "非經常性給予": "irregular" }.freeze

  class << self
    def years
      distinct.pluck(:year)
    end

    def salary_income(year)
      where(tax_code: "50", year: year)
    end

    # 勞務報酬的會計月份是以「發放日期」計算，因隔月發薪，報表需要往前移一個月
    def service_income(year)
      where("tax_code = '9a' AND year = ? AND month = 12", year - 1)
        .or(where("tax_code = '9a' AND year = ? AND month < 12", year))
    end

    def ordered
      order(employee_id: :asc, year: :asc, month: :asc)
    end
  end

  def adjusted_amount
    amount - subsidy_income - festival_bonus + correction.to_i
  end
end
