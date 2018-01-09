# frozen_string_literal: true
class Employee < ApplicationRecord
  has_many :salaries, dependent: :destroy
  has_many :payrolls, dependent: :destroy

  def regular?
    type == RegularEmployee
  end

  def contractor?
    type == ContractorEmployee
  end

  def parttime?
    type == ParttimeEmployee
  end
end
