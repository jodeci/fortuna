# frozen_string_literal: true
class Report < ApplicationRecord
  INCOME_TYPE = { "薪資+三節獎金": "salary", "勞務報酬": "service", "非經常性給予": "irregular" }.freeze

  scope :years, -> { (distinct.pluck(:year).min..Date.today.year + 1).to_a }
  scope :ordered, -> { order(employee_id: :asc, year: :asc, month: :asc) }
  scope :salary_income, ->(year) { where(tax_code: "50", year: year) }
  scope :salary_income_by_month, ->(year, month) { where(tax_code: "50", year: year, month: month) }

  scope :column_by_month, ->(year, month, column) { where(tax_code: "50", year: year, month: month).pluck(column) }

  # 勞務報酬的會計月份是以「發放日期」計算，因隔月發薪，報表需要往前移一個月
  scope :service_income, ->(year) {
    where("tax_code = '9a' AND year = ? AND month = 12", year - 1)
      .or(where("tax_code = '9a' AND year = ? AND month < 12", year))
  }

  # 三節獎金屬於「薪資」，但報表上是和當月薪資分開顯示，故單月加總時需排除
  scope :sum_by_month, ->(year:, month:, tax_code:) {
    where(tax_code: tax_code, year: year, month: month).sum_amount_without_festival
  }

  scope :sum_by_festival, ->(year, festival) {
    salary_income(year).where(festival_type: festival).sum(:festival_bonus).to_i
  }

  scope :sum_salary_income_for, ->(year, employee_id) {
    salary_income(year).where(employee_id: employee_id).sum_amount
  }

  scope :sum_service_income_for, ->(year, employee_id) {
    service_income(year).where(employee_id: employee_id).sum_amount
  }

  scope :sum_amount, -> {
    pluck(Arel.sql("SUM(amount), SUM(correction), SUM(subsidy_income) * -1"))
      .flatten
      .reduce(0) { |sum, column| sum + column.to_i }
  }

  scope :sum_amount_without_festival, -> {
    pluck(Arel.sql("SUM(amount), SUM(correction), SUM(subsidy_income) * -1, SUM(festival_bonus) * -1"))
      .flatten
      .reduce(0) { |sum, column| sum + column.to_i }
  }

  def adjusted_amount
    amount - subsidy_income - festival_bonus + correction.to_i
  end
end
