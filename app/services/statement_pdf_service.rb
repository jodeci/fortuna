# frozen_string_literal: true
class StatementPDFService
  attr_reader :statement, :details, :renderer

  def initialize(statement)
    @statement = statement
    @details = StatementDetailsService.new(statement).run
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
    "#{filename_prefix}-#{statement.employee.name}.pdf"
  end

  def email_subject
    filename_prefix
  end

  private

  def save_pdf
    File.write(pdf_file_path, generate_pdf, mode: "wb")
  end

  def encrypt_pdf
    PDF::Toolkit.pdftk(pdf_file_path, "output", encrypt_file_path, "user_pw", statement.employee.id_number)
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

  def filename_prefix
    "#{statement.year}-#{sprintf('%02d', statement.month)} 薪資明細"
  end

  def html_content
    renderer.render(
      layout: "pdf.pdf",
      file: details[:template],
      assigns: { details: details }
    )
  end

  def template
    statement.splits? ? "split" : "show"
  end
end
