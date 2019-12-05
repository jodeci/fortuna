# frozen_string_literal: true
module YearendBonusService
  class AverageWage
    include Callable

    attr_reader :employee, :cycle_end

    def initialize(employee, cycle_end)
      @employee = employee
      @cycle_end = cycle_end
    end

    # 平均工資依勞基法回推六個月，並只計算正職期間
    def call
      return 0 unless regular_during_cycle?

      months = 0
      total = 0

      past_six_months_salaries.map do |salary|
        next unless salary[:role] == "regular"
        months += 1
        total += salary[:monthly_wage]
      end
      return 0 if (total * months).zero?
      total.quo(months).to_f.round(2)
    end

    private

    def regular_during_cycle?
      past_six_months_salaries.first[:role] == "regular"
    end

    def past_six_months_salaries
      salaries = []
      0.upto(5) do |i|
        salary = SalaryService::Finder.call(
          employee, (cycle_end - i.months).at_beginning_of_month, (cycle_end - i.months).at_end_of_month
        )
        salaries << { monthly_wage: salary.monthly_wage, role: salary.role }
      end
      salaries
    end
  end
end
