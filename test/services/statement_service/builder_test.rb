# frozen_string_literal: true
require "test_helper"

module StatementService
  class BuilderTest < ActiveSupport::TestCase
    def test_builds_statement
      subject = prepare_subject
      StatementService::Builder.any_instance.expects(:statement).returns(Statement.new)
      Statement.any_instance.expects(:update).returns(true)
      assert StatementService::Builder.call(subject)
    end

    private

    def prepare_subject
      build(
        :payroll,
        year: 2018,
        month: 1,
        salary: build(:salary),
        employee: build(:employee)
      )
    end
  end
end
