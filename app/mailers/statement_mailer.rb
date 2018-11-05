# frozen_string_literal: true

class StatementMailer < ApplicationMailer
  def notify_email(statement)
    attachments[builder.filename] = builder.encrypted_pdf
    mail(
      to: statement.employee.email,
      bcc: ENV["statement_bcc"].split(","),
      subject: builder.email_subject
    )
    builder.delete_files
  end

  private

  def builder
    @builder ||= StatementPDFBuilder.new(statement)
  end
end
