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

  def filename
    "#{filename_prefix}-#{statement.employee.name}.pdf"
  end

  def email_subject
    filename_prefix
  end

  private

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
