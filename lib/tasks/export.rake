# frozen_string_literal: true

namespace :export do
  # 依玉山銀行 系統管理>檔案上傳自訂格式 設計
  desc "export statement to csv for bank transfer"
  task csv: :environment do
    unless ENV["year"] and ENV["month"] and ENV["path"] and ENV["paydate"]
      abort "usage: rake export:csv year=2018 month=2 path=tmp paydate=yyyymmdd"
    end

    statements = Statement.by_payroll(ENV["year"], ENV["month"]).paid.group_by(&:employee_bank_transfer_type)

    # 薪資轉帳
    salary_transfers = statements["salary"].group_by { |statement| statement.payroll.salary.role }
    %w(parttime advisor).each do |key|
      if salary_transfers[key]
        salary_transfers["contractor"].concat salary_transfers[key]
        salary_transfers.delete key
      end
    end

    salary_transfers.each do |role, grouped_statements|
      filename = "#{ENV['year']}#{sprintf('%02d', ENV['month'])}_#{role}.csv"
      File.write(
        File.join(ENV["path"], filename),
        EsunBankCSVService.call(grouped_statements, "salary", ENV["paydate"]),
        encoding: "big5"
      )
    end

    # 台幣轉帳
    if statements["normal"]
      filename = "#{ENV['year']}#{sprintf('%02d', ENV['month'])}_normal_transfer.csv"
      File.write(
        File.join(ENV["path"], filename),
        EsunBankCSVService.call(statements["normal"], "normal", ENV["paydate"]),
        encoding: "big5"
      )
    end
  end

  desc "export statements to pdf"
  task pdf: :environment do
    unless ENV["year"] and ENV["month"] and ENV["path"]
      abort "usage: rake export:pdf year=2018 month=2 path=tmp"
    end

    Statement.by_payroll(ENV["year"], ENV["month"]).paid.each do |statement|
      builder = StatementPDFBuilder.new(statement)
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

    Statement.by_payroll(ENV["year"], ENV["month"]).paid.each do |statement|
      StatementMailer.notify_email(statement).deliver
    end
  end
end
