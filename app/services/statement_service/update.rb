# frozen_string_literal: true
module StatementService
  class Update
    include Callable
    attr_reader :statement, :params

    def initialize(statement, params)
      @statement = statement
      @params = params
    end

    def call
      params["correction"] = correction
      statement.update(params)
    end

    private

    def correction
      sum = 0
      params["corrections_attributes"].each do |row|
        sum += row[1][:amount].to_i if row[1][:_destroy] == "false"
      end
      sum
    end
  end
end
