# frozen_string_literal: true
class MinimumWageService
  include Callable

  attr_reader :date

  def initialize(year, month)
    @date = Date.new(year, month, 1)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity
  def call
    if date >= Date.new(2022, 1, 1)
      25250
    elsif date >= Date.new(2021, 1, 1)
      24000
    elsif date >= Date.new(2020, 1, 1)
      23800
    elsif date >= Date.new(2019, 1, 1)
      23100
    elsif date >= Date.new(2018, 1, 1)
      22000
    elsif date >= Date.new(2017, 1, 1)
      21009
    elsif date >= Date.new(2016, 10, 1)
      20008
    elsif date >= Date.new(2014, 7, 1)
      19273
    elsif date >= Date.new(2014, 1, 1)
      19047
    else
      18780 # 再往下寫沒意義
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/PerceivedComplexity
end
