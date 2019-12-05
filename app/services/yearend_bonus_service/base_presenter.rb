# frozen_string_literal: true
module YearendBonusService
  class BasePresenter
    include Callable

    attr_reader :employee, :lunar_year

    Presenter = Struct.new(
      :name, :role, :year, :last_working_day, :average_wage, :seniority_factor,
      :employee_id, :lunar_year_id, keyword_init: true
    )

    def initialize
    end

    def call
      Presenter.new(
        name: employee.name,
        role: closing_salary.given_role,
        year: lunar_year.year,
        last_working_day: lunar_year.last_working_day,
        average_wage: average_wage,
        seniority_factor: seniority_factor,
        employee_id: employee.id,
        lunar_year_id: lunar_year.id
      )
    end

    private

    # TODO
    def seniority_factor
      1
    end

    def average_wage
      YearendBonusService::AverageWage.call(employee, lunar_year.last_working_day)
    end

    def closing_salary
      SalaryService::Finder.call(employee, cycle_start, cycle_end)
    end

    def cycle_start
      lunar_year.last_working_day.at_beginning_of_month
    end

    def cycle_end
      lunar_year.last_working_day.at_end_of_month
    end
  end
end
