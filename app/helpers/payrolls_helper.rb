# frozen_string_literal: true
module PayrollsHelper
  def init_year
    q_year.between?(2014, Time.zone.today.year + 1) ? q_year : Time.zone.today.year
  end

  def init_month
    q_month.between?(1, 12) ? q_month : Time.zone.today.month
  end

  def init_button_text
    "產生薪資單：#{init_year}-#{sprintf('%02d', init_month)}"
  end

  private

  def q_year
    params.dig(:q, :year_eq).to_i
  end

  def q_month
    params.dig(:q, :month_eq).to_i
  end
end
