# frozen_string_literal: true
class StatementPDFBuilder
  attr_reader :statement, :details, :renderer

  def initialize(statement)
    @statement = statement
    @details = FormatService::StatementDetails.call(statement)
    @renderer = StatementsController.renderer.new
  end

  def generate_pdf
    WickedPdf.new.pdf_from_string(
      html_content,
      encoding: "utf-8",
      orientation: "landscape"
    )
  end

  def encrypted_pdf
    save_pdf
    encrypt_pdf
    File.read(encrypt_file_path)
  end

  def delete_files
    File.delete(pdf_file_path)
    File.delete(encrypt_file_path)
  end

  def filename
    "#{filename_prefix}-#{statement.employee_name}.pdf"
  end

  def email_subject
    filename_prefix
  end

  private

  def save_pdf
    File.write(pdf_file_path, generate_pdf, mode: "wb")
  end

  def encrypt_pdf
    PDF::Toolkit.pdftk(pdf_file_path, "output", encrypt_file_path, "user_pw", encrypt_password)
  end

  def pdf_file_path
    File.join(temp_dir, "source", filename)
  end

  def encrypt_file_path
    File.join(temp_dir, "encrypted", filename)
  end

  def temp_dir
    "tmp/pdfs"
  end

  def encrypt_password
    statement.employee_id_number
  end

  def filename_prefix
    "#{statement.year}-#{sprintf('%02d', statement.month)} 薪資明細"
  end

  def html_content
    renderer.render(
      layout: "pdf.pdf",
      template: details[:template],
      assigns: { details: details }
    )
  end

  def template
    statement.splits? ? "split" : "show"
  end
end
