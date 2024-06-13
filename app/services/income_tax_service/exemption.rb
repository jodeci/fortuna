# frozen_string_literal: true
module IncomeTaxService
  class Exemption
    include Callable

    attr_reader :date

    # 薪資所得扣繳稅額表無配偶及受扶養親屬者之起扣標準（也太長）
    def initialize(year, month)
      @date = Date.new(year, month, 1)
    end

    def call
      exemption_by_date
    end

    private

    def exemption_by_date
      if date >= Date.new(2024, 1, 1)
        88500
      elsif date >= Date.new(2022, 1, 1)
        86000
      elsif date >= Date.new(2018, 1, 1)
        84500
      elsif date >= Date.new(2017, 1, 1)
        73500
      else
        73000 # 再往下寫沒意義
      end
    end
  end
end
