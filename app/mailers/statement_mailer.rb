# frozen_string_literal: true

class StatementMailer < ApplicationMailer
  def notify_email(statement)
    @statement = statement
    mail(
      to: statement.employee.email,
      subject: "#{statement.year}-#{sprintf('%02d', statement.month)} 薪資明細"
    )
  end
end
