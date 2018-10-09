SELECT DISTINCT
  employees.id AS employee_id,
  payrolls.id AS payroll_id,
  statements.id AS statement_id,
  employees.name,
  payrolls.year,
  payrolls.month,
  salaries.tax_code,
  statements.amount
FROM employees
INNER JOIN payrolls ON employees.id = payrolls.employee_id
INNER JOIN salaries ON salaries.id = payrolls.salary_id
INNER JOIN statements ON payrolls.id = statements.payroll_id
