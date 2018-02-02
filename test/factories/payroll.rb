FactoryBot.define do
  factory :payroll do

    transient do
      build_statement_immediatedly false
    end

    after :create do |payroll, ev|
      StatementService.new(payroll).build if ev.build_statement_immediatedly
    end

  end
end
