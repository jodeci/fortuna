# frozen_string_literal: true

namespace :export do
  # 依玉山銀行 系統管理>檔案上傳自訂格式 設計
  desc "export statement to csv for bank transfer"
  task csv: :environment do
    unless ENV["year"] and ENV["month"] and ENV["path"] and ENV["paydate"]
      abort "usage: rake export:csv year=2018 month=2 path=tmp paydate=yyyymmdd"
    end

    statements = Statement.by_payroll(ENV["year"], ENV["month"]).group_by do |statement|
      statement.employee.bank_transfer_type
    end

    # 薪資轉帳
    salary_transfers = statements["salary"].group_by { |statement| statement.payroll.salary.role }
    salary_transfers["contractor"].concat salary_transfers["parttime"]
    salary_transfers.delete "parttime"

    salary_transfers.each do |role, grouped_statements|
      filename = "#{ENV['year']}#{sprintf('%02d', ENV['month'])}_#{role}.csv"
      File.write(
        File.join(ENV["path"], filename),
        EsunBankCSVService.new(grouped_statements, "salary", ENV["paydate"]).csv_rows,
        encoding: "big5"
      )
    end

    # 台幣轉帳
    filename = "#{ENV['year']}#{sprintf('%02d', ENV['month'])}_ntd_transfer.csv"
    File.write(
      File.join(ENV["path"], filename),
      EsunBankCSVService.new(statements["ntd"], "ntd", ENV["paydate"]).csv_rows,
      encoding: "big5"
    )
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
