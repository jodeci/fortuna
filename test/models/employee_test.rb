# frozen_string_literal: true
require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  def test_email
    Timecop.freeze(Date.new(2018, 2, 19)) do
      assert_equal "jack@5xruby.tw", jack.email
    end

    Timecop.freeze(Date.new(2018, 3, 19)) do
      assert_equal "jack@gmail.com", jack.email
    end

    Timecop.freeze(Date.new(2018, 9, 20)) do
      assert_equal "jack@5xruby.tw", jack.email
    end
  end

  def test_scope_ordered
    5.times { create(:employee) }
    assert Employee.ordered.each_cons(2).all? { |first, second| first.id >= second.id }
  end

  def test_term
    employee = build(:employee)
    term1 = create(:term, start_date: "2017-12-18", end_date: "2018-08-16", employee: employee)
    term2 = create(:term, start_date: "2018-11-12", employee: employee)

    assert_nil employee.term(Date.new(2017, 11, 1), Date.new(2017, 11, -1))
    assert_equal term1, employee.term(Date.new(2017, 12, 1), Date.new(2017, 12, -1))
    assert_equal term1, employee.term(Date.new(2018, 8, 1), Date.new(2018, 8, -1))
    assert_nil employee.term(Date.new(2018, 9, 1), Date.new(2018, 9, -1))
    assert_equal term2, employee.term(Date.new(2018, 11, 1), Date.new(2018, 11, -1))
    assert_equal term2, employee.term(Date.new(2018, 12, 1), Date.new(2018, 12, -1))

    assert_equal term2, employee.recent_term
  end

  private

  def john
    @john ||= create(
      :employee,
      company_email: "john@5xruby.tw",
      personal_email: "john@gmail.com"
    ) { |employee| create(:term, start_date: "2017-01-01", employee: employee) }
  end

  def jack
    @jack ||= create(
      :employee,
      company_email: "jack@5xruby.tw",
      personal_email: "jack@gmail.com"
    ) do |employee|
      create(:term, start_date: "2017-10-01", end_date: "2018-02-06", employee: employee)
      create(:term, start_date: "2018-09-13", end_date: nil, employee: employee)
    end
  end

  def jane
    @jane ||= create(
      :employee,
      company_email: nil,
      personal_email: "jane@gmail.com"
    ) { |employee| create(:term, start_date: "2018-03-01", employee: employee) }
  end
end
