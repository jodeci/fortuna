# frozen_string_literal: true
class MinimumWageService
  include Callable

  attr_reader :date, :brackets

  def initialize(year, month)
    @date = Date.new(year, month, 1)
    @brackets = []
  end

  def call
    parse_yml_data_to_brackets

    brackets.each do |bracket|
      return bracket[:minimum_wage] if bracket[:range].cover?(date)
    end
  end

  private

  def parse_yml_data_to_brackets
    yml_data.each do |row|
      d1 = Date.parse(row["start"])
      d2 = end_date_infinity_check(row["end"])
      brackets << { range: d1..d2, minimum_wage: row["value"] }
    end
  end

  def end_date_infinity_check(end_date)
    if end_date == "infinity"
      Date::Infinity.new
    else
      Date.parse(end_date)
    end
  end

  def yml_data
    YAML.load_file("#{Rails.root}/config/minimum_wage.yml")
  end
end
