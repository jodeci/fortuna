SELECT DISTINCT
  employees.id AS employee_id,
  payrolls.id AS payroll_id,
  employees.name,
  employees.id_number,
  employees.residence_address,
  payrolls.year,
  payrolls.month,
  salaries.tax_code,
  statements.amount,
  statements.subsidy_income,
  payrolls.festival_bonus,
  payrolls.festival_type,
  SUM(corrections.amount) AS correction
FROM employees
INNER JOIN payrolls ON employees.id = payrolls.employee_id
INNER JOIN salaries ON salaries.id = payrolls.salary_id
INNER JOIN statements ON payrolls.id = statements.payroll_id
LEFT OUTER JOIN corrections ON statements.id = corrections.statement_id
WHERE employees.b2b = false
GROUP BY employees.id, payrolls.id, statements.id, salaries.tax_code
