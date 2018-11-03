# frozen_string_literal: true
require "test_helper"
require "minitest/mock"

module IncomeTaxService
  class DispatcherTest < ActiveSupport::TestCase
    def test_bypass_when_business
      subject = prepare_subject(tax_code: nil, insured: 0, b2b: true)
      assert_equal 0, IncomeTaxService::Dispatcher.call(subject)
    end

    def test_dispatches_to_professional_service
      subject = prepare_subject(tax_code: "9a", insured: 0, b2b: false)
      mock = MiniTest::Mock.new
      mock.expect(:call, 0, [subject])

      IncomeTaxService::ProfessionalService.stub :call, mock do
        assert IncomeTaxService::Dispatcher.call(subject)
      end

      assert_mock mock
    end

    def test_dispatches_to_uninsuranced_salary
      subject = prepare_subject(tax_code: 50, insured: 0, b2b: false)
      mock = MiniTest::Mock.new
      mock.expect(:call, 0, [subject])

      IncomeTaxService::UninsurancedSalary.stub :call, mock do
        assert IncomeTaxService::Dispatcher.call(subject)
      end

      assert_mock mock
    end

    def test_dispatches_to_irregular_income
      subject = prepare_subject(tax_code: 50, insured: 11100, b2b: false)
      mock = MiniTest::Mock.new
      mock.expect(:call, 0, [subject])

      IncomeTaxService::IrregularIncome.stub :call, mock do
        assert IncomeTaxService::Dispatcher.call(subject)
      end

      assert_mock mock
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
