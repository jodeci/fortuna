# frozen_string_literal: true

namespace :export do
  # 依玉山銀行 系統管理>檔案上傳自訂格式 設計
  desc "export statement to csv for bank transfer"
  task csv: :environment do
    unless ENV.fetch("year") && ENV.fetch("month") && ENV.fetch("path") && ENV["paydate"]
      abort "usage: rake export:csv year=2018 month=2 path=tmp paydate=yyyymmdd"
    end

    statements = Statement.by_payroll(ENV.fetch("year"), ENV.fetch("month")).paid.group_by(&:employee_bank_transfer_type)

    # 薪資轉帳
    salary_transfers = statements["salary"].group_by { |statement| statement.payroll.salary.role }
    %w(parttime advisor vendor).each do |key|
      if salary_transfers[key]
        salary_transfers["contractor"].concat salary_transfers[key]
        salary_transfers.delete key
      end
    end

    salary_transfers.each do |role, grouped_statements|
      filename = "#{ENV.fetch('year')}#{sprintf('%02d', ENV.fetch('month'))}_#{role}.csv"
      File.write(
        File.join(ENV.fetch("path"), filename),
        EsunBankCSVService.call(grouped_statements, "salary", ENV.fetch("paydate")),
        encoding: "big5"
      )
    end

    # 台幣轉帳
    if statements["normal"]
      filename = "#{ENV.fetch('year')}#{sprintf('%02d', ENV.fetch('month'))}_normal_transfer.csv"
      File.write(
        File.join(ENV.fetch("path"), filename),
        EsunBankCSVService.call(statements["normal"], "normal", ENV.fetch("paydate")),
        encoding: "big5"
      )
    end

    # ATM/臨櫃轉帳
    if statements["atm"]
      filename = "#{ENV.fetch('year')}#{sprintf('%02d', ENV.fetch('month'))}_atm.csv"
      File.write(
        File.join(ENV.fetch("path"), filename),
        EsunBankCSVService.call(statements["atm"], "atm", ENV.fetch("paydate")),
        encoding: "utf-8" # 給人類看的
      )
    end
  end

  desc "export statements to pdf"
  task pdf: :environment do
    unless ENV.fetch("year") && ENV.fetch("month") && ENV["path"]
      abort "usage: rake export:pdf year=2018 month=2 path=tmp"
    end

    Statement.by_payroll(ENV.fetch("year"), ENV.fetch("month")).paid.each do |statement|
      builder = StatementPDFBuilder.new(statement)
      File.write(
        File.join(ENV.fetch("path"), builder.filename),
        builder.generate_pdf,
        mode: "wb"
      )
    end
  end

  desc "export statment to pdf"
  task statement: :environment do
    unless ENV["id"] && ENV["path"]
      abort "usage: rake export:statement id={statement_id} path=tmp"
    end

    builder = StatementPDFBuilder.new(Statement.find(ENV.fetch("id")))
    File.write(
      File.join(ENV.fetch("path"), builder.filename),
      builder.generate_pdf,
      mode: "wb"
    )
  end

  desc "send pdf as attachment to employee"
  task email: :environment do
    unless ENV["year"] && ENV["month"]
      abort "usage: rake export:email year=2018 month=2"
    end

    Statement.by_payroll(ENV.fetch("year"), ENV.fetch("month")).paid.each do |statement|
      next if statement.employee.email.blank?
      StatementMailer.notify_email(statement).deliver
    end
  end

  desc "send statement to specific employee"
  task mailto: :environment do
    unless ENV["id"]
      abort "usage: rake export:mailto id={statement_id}"
    end

    statement = Statement.find(ENV.fetch("id"))
    if statement.employee.email.present?
      StatementMailer.notify_email(statement).deliver
    end
  end
end
