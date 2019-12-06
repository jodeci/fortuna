# frozen_string_literal: true
module YearendBonusService
  class Reciptents
    include Callable

    attr_reader :lunar_year

    Presenter = Struct.new(
      :employee_id, :name, :role, :bonus_id, :total, keyword_init: true
    )

    def initialize(lunar_year)
      @lunar_year = lunar_year
    end

    def call
      reciptents = []
      employees_during_yearend.map do |employee|
        reciptent = YearendBonusService::Reciptent.new(employee, lunar_year)
        next unless reciptent.eligible?

        reciptents << Presenter.new(reciptent.params)
      end
      reciptents
    end

    private

    def employees_during_yearend
      Employee
        .on_payroll(lunar_year.last_working_day - 1.month, lunar_year.last_working_day)
        .ordered
    end
  end

  class Reciptent
    attr_reader :employee, :salary, :bonus

    def initialize(employee, lunar_year)
      @employee = employee
      @bonus = YearendBonus.fetch(employee, lunar_year)
      @salary = SalaryService::Finder.call(
        employee, lunar_year.last_working_day.at_beginning_of_month, lunar_year.last_working_day
      )
    end

    def params
      {
        employee_id: employee.id,
        name: employee.name,
        role: salary.given_role,
        bonus_id: bonus.id,
        total: bonus.total,
      }
    end

    def eligible?
      %w(regular boss contractor).include? salary.role
    end
  end
end
