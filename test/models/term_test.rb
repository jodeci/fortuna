# frozen_string_literal: true
require "test_helper"

class TermTest < ActiveSupport::TestCase
  def test_scope_ordered
    prepare_scope_ordered

    assert Term.ordered.each_cons(2).all? do |first, second|
      first.start_date >= second.start_date
    end
  end

  private

  def prepare_scope_ordered
    create(:term, start_date: "2018-05-05", employee: build(:employee))
    create(:term, start_date: "2018-10-01", employee: build(:employee))
    create(:term, start_date: "2018-01-23", employee: build(:employee))
  end
end
