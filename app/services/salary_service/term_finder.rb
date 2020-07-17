# frozen_string_literal: true
module SalaryService
  class TermFinder
    include Callable

    attr_reader :salary, :terms

    def initialize(salary)
      @salary = salary
      @terms = salary.employee.terms
    end

    def call
      find_term
    end

    private

    def find_term
      terms.map do |term|
        return term if salary_match?(term)
      end
    end

    def salary_match?(term)
      salary.effective_date.between? term.start_date, end_date(term)
    end

    def end_date(term)
      term.end_date || Date.today
    end
  end
end
