# frozen_string_literal: true
module StatementDecorator
  def declared_income
    amount - irregular_income + correct_by
  end

  def declared_income_cell
    content_tag :td, class: declared_income_style do
      number_with_delimiter(declared_income)
    end
  end

  def paid_amount
    amount + correct_by
  end

  def paid_amount_cell
    content_tag :td, class: paid_amount_style do
      number_with_delimiter(paid_amount)
    end
  end

  private

  def declared_income_style
    irregular_income.positive? ? "highlight" : nil
  end

  def paid_amount_style
    corrections? ? "highlight" : nil
  end
end
