SELECT
  employees.id AS employee_id,
  terms.id AS term_id,
  salaries.id AS salary_id,
  employees.name AS name,
  terms.start_date AS term_start,
  terms.end_date AS term_end,
  salaries.role AS role,
  salaries.effective_date AS salary_start
FROM employees
INNER JOIN terms ON employees.id = terms.employee_id
INNER JOIN salaries ON employees.id = salaries.employee_id
WHERE salaries.term_id = terms.id
