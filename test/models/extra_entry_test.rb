# frozen_string_literal: true
require "test_helper"

class ExtraEntryTest < ActiveSupport::TestCase
  def test_scope_yearly_subsidy_report
    prepare_scope_yearly_subsidy_report(year: 2017, subsidies: 5)
    prepare_scope_yearly_subsidy_report(year: 2018, subsidies: 3)

    assert ExtraEntry.yearly_subsidy_report(2017).count, 5
    assert ExtraEntry.yearly_subsidy_report(2018).count, 3
  end

  private

  def prepare_scope_yearly_subsidy_report(year:, subsidies:)
    create(:payroll, year: year, salary: build(:salary), employee: build(:employee)) do |payroll|
      subsidies.times { create(:extra_entry, amount: 1, income_type: "subsidy", payroll: payroll) }
    end
  end
end
