# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: "salary@5xruby.tw"
  layout "mailer"
end
