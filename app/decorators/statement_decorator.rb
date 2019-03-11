# frozen_string_literal: true
module StatementDecorator
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::NumberHelper
  include ActionView::Context

  def declared_income
    amount - subsidy_income + correct_by
  end

  def declared_income_cell
    content_tag :td, class: declared_income_style do
      number_with_delimiter(declared_income)
    end
  end

  def paid_amount_cell
    content_tag :td, class: paid_amount_style do
      number_with_delimiter(amount + correct_by)
    end
  end

  private

  def declared_income_style
    subsidy_income.positive? ? "highlight" : nil
  end

  def paid_amount_style
    corrections? ? "highlight" : nil
  end
end
