# frozen_string_literal: true
require "test_helper"

module IncomeTaxService
  class DispatcherTest < ActiveSupport::TestCase
    def test_bypass_when_business
      subject = prepare_subject(tax_code: nil, insured: 0, b2b: true)
      assert_equal 0, IncomeTaxService::Dispatcher.call(subject)
    end

    def test_dispatches_to_professional_service
      subject = prepare_subject(tax_code: "9a", insured: 0, b2b: false)
      IncomeTaxService::ProfessionalService.expects(:call).returns(true)
      assert IncomeTaxService::Dispatcher.call(subject)
    end

    def test_dispatches_to_uninsuranced_salary
      subject = prepare_subject(tax_code: 50, insured: 0, b2b: false)
      IncomeTaxService::UninsurancedSalary.expects(:call).returns(true)
      assert IncomeTaxService::Dispatcher.call(subject)
    end

    def test_dispatches_to_regular_employee
      subject = prepare_subject(tax_code: 50, insured: 11100, b2b: false)
      IncomeTaxService::RegularEmployee.expects(:call).returns(true)
      assert IncomeTaxService::Dispatcher.call(subject)
    end

    private

    def prepare_subject(tax_code:, insured:, b2b:)
      build(
        :payroll,
        salary: build(:salary, tax_code: tax_code, insured_for_labor: insured),
        employee: build(:employee, b2b: b2b)
      )
    end
  end
end
