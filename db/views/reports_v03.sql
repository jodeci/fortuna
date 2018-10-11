SELECT DISTINCT
  employees.id AS employee_id,
  payrolls.id AS payroll_id,
  statements.id AS statement_id,
  employees.name,
  payrolls.year,
  payrolls.month,
  salaries.tax_code,
  statements.amount,
  statements.irregular_income,
  SUM(corrections.amount) AS correction
FROM employees
INNER JOIN payrolls ON employees.id = payrolls.employee_id
INNER JOIN salaries ON salaries.id = payrolls.salary_id
INNER JOIN statements ON payrolls.id = statements.payroll_id
LEFT OUTER JOIN corrections ON statements.id = corrections.statement_id
GROUP BY employees.id, payrolls.id, statements.id, salaries.tax_code
