# frozen_string_literal: true
module SalaryService
  class Destroy < Base
    def call
      salary.destroy
      sync_payroll_relations
      sync_statements
    end

    private

    def effective_date
      nil
    end
  end
end
