SELECT DISTINCT
  employees.id AS employee_id,
  payrolls.id AS payroll_id,
  payrolls.year,
  payrolls.month,
  salaries.tax_code,
  salaries.monthly_wage,
  salaries.insured_for_health,
  statements.splits,
  statements.amount,
  statements.subsidy_income,
  statements.bonus_income,
  employees.owner
FROM employees
INNER JOIN payrolls ON employees.id = payrolls.employee_id
INNER JOIN salaries ON salaries.id = payrolls.salary_id
INNER JOIN statements ON payrolls.id = statements.payroll_id
WHERE employees.b2b = false
