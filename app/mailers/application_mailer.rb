# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("email_sender")
  layout "mailer"
end
