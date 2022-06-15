# frozen_string_literal: true
require "test_helper"

class PayrollInitRegularsServiceTest < ActiveSupport::TestCase
  def test_call
    6.times { prepare_subject(role: "regular") }
    5.times { prepare_subject(role: "contractor") }
    4.times { prepare_subject(role: "boss") }
    3.times { prepare_subject(role: "advisor") }
    2.times { prepare_subject(role: "vendor") }
    prepare_subject(role: "parttime")

    PayrollInitService.expects(:call).times(15)
    assert PayrollInitRegularsService.call(2018, 1)
  end

  private

  def prepare_subject(role:)
    create(:employee) do |employee|
      create(
        :salary,
        effective_date: "2018-01-01",
        role: role,
        employee: employee,
        term: create(:term, start_date: "2018-01-01", employee: employee)
      )
    end
  end
end
