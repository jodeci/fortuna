# frozen_string_literal: true

FactoryBot.define do
  factory :payroll do
    transient do
      build_statement_immediatedly { false }
    end

    after :create do |payroll, ev|
      StatementService::Builder.call(payroll) if ev.build_statement_immediatedly
    end
  end
end
