# frozen_string_literal: true
class StatementPDFService
  attr_reader :details, :renderer

  def initialize(statement)
    @renderer = StatementsController.renderer.new
    @details = StatementDetailsService.new(statement).run
  end

  def generate_pdf
    WickedPdf.new.pdf_from_string(
      html_content,
      encoding: "utf-8",
      orientation: "landscape"
    )
  end

  def filename
    "#{statement.year}-#{sprintf('%02d', statement.month)} 薪資明細-#{statement.employee.name}.pdf"
  end

  private

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
