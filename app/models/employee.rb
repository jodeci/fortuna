# frozen_string_literal: true
class Employee < ApplicationRecord
  has_many :salaries, dependent: :destroy
  accepts_nested_attributes_for :salaries

  has_many :payrolls, dependent: :destroy

  def regular?
    role == "regular"
  end

  def contractor?
    role == "contractor"
  end

  def parttime?
    role == "parttime"
  end
end
