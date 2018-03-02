# frozen_string_literal: true

namespace :export do
  # 依玉山銀行薪EASY自訂格式設計
  desc "export statement to csv for bank transfer"
  task csv: :environment do
    unless ENV["year"] and ENV["month"] and ENV["path"]
      abort "usage: rake export:csv year=2018 month=2 path=tmp"
    end

    statements = Statement.by_payroll(ENV["year"], ENV["month"]).group_by do |statement|
      statement.payroll.salary.role
    end

    statements["contractor"].concat statements["parttime"]
    statements.delete "parttime"

    statements.each do |role, grouped_statements|
      filename = "#{ENV['year']}#{sprintf('%02d', ENV['month'])}_#{role}.csv"
      File.write(
        File.join(ENV["path"], filename),
        EsunBankCSVService.new(grouped_statements).csv_rows,
        encoding: "big5"
      )
    end
  end

  desc "export statements to pdf"
  task pdf: :environment do
    unless ENV["year"] and ENV["month"] and ENV["path"]
      abort "usage: rake export:pdf year=2018 month=2 path=tmp"
    end

    Statement.by_payroll(ENV["year"], ENV["month"]).each do |statement|
      builder = StatementPDFService.new(statement)
      File.write(
        File.join(ENV["path"], builder.filename),
        builder.generate_pdf,
        mode: "wb"
      )
    end
  end

  desc "send pdf as attachment to employee"
  task email: :environment do
    unless ENV["year"] and ENV["month"]
      abort "usage: rake export:email year=2018 month=2"
    end

    Statement.by_payroll(ENV["year"], ENV["month"]).each do |statement|
      StatementMailer.notify_email(statement).deliver
    end
  end
end
