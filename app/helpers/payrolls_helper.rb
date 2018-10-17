# frozen_string_literal: true
module PayrollsHelper
  def init_year
    q_year.between?(2014, this_year + 1) ? q_year : this_year
  end

  def init_month
    q_month.between?(1, 12) ? q_month : this_month
  end

  def init_button_text
    "產生薪資單：#{init_year}-#{sprintf('%02d', init_month)}"
  end

  private

  def this_year
    Time.zone.today.year
  end

  def this_month
    Time.zone.today.month
  end

  def q_year
    params.dig(:query, :year_eq).to_i
  end

  def q_month
    params.dig(:query, :month_eq).to_i
  end
end
