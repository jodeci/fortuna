# frozen_string_literal: true
class Employee < ApplicationRecord
  include CollectionTranslatable

  has_many :salaries, dependent: :destroy
  accepts_nested_attributes_for :salaries, allow_destroy: true

  has_many :payrolls, dependent: :destroy
  has_many :statements, through: :payrolls, source: :statement
  has_many :terms, dependent: :destroy

  BANK_TRANSFER_TYPE = { "薪資轉帳": "salary", "台幣轉帳": "normal", "ATM/臨櫃": "atm" }.freeze

  scope :ordered, -> { order(id: :desc) }

  def term(cycle_start, cycle_end)
    terms.find_by("start_date <= ? AND (end_date >= ? OR end_date IS NULL)", cycle_end, cycle_start)
  end

  def email
    return personal_email if resigned? || company_email.blank?
    company_email
  end

  def recent_term
    terms.ordered.first
  end

  private

  # 離職當月仍算是在職
  def resigned?
    return true if current_term.blank?
    return false unless current_term.end_date
    current_term.end_date < Date.today.beginning_of_month
  end

  def current_term
    term(Date.today.at_beginning_of_month, Date.today.at_end_of_month)
  end
end
