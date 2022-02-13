SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' and '1955-12-31')
ORDER BY e.emp_no;


-- Use DISTINCT with ORDER BY to remove duplicate rows.
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

SELECT * FROM unique_titles;

-- Retrieve the number of employees by their most recent job title who are about to retire.
SELECT COUNT (title) AS count
FROM unique_titles;

-- Create a Retiring Titles table.
SELECT COUNT (title) AS count, title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles;

-- Sum of employees who are about to retire.
SELECT SUM (count)
FROM retiring_titles;

-- Write a query to create a Mentorship Eligibility table.
SELECT DISTINCT ON (emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees as e
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '12-31-1965')
ORDER BY e.emp_no;

SELECT * FROM mentorship_eligibility;


SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' and '1955-12-31')
ORDER BY e.emp_no;


-- Use DISTINCT with ORDER BY to remove duplicate rows.
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

-- Retrieve the number of employees by their most recent job title who are about to retire.
SELECT COUNT (title) AS count
FROM unique_titles;

-- Create a Retiring Titles table.
SELECT COUNT (title) AS count, title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles;

-- Create a mentorship eligiblity table by department
SELECT DISTINCT ON (emp_no) e.emp_no,
	d.dept_name
INTO mentorship_eligibility_2
FROM employees as e
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '12-31-1965');

SELECT COUNT (emp_no) AS count1, dept_name
INTO mentorship_eligibility_dept
FROM mentorship_eligibility_2
GROUP BY dept_name
ORDER BY dept_name;

SELECT * FROM mentorship_eligibility_dept;

-- Calculate the number of retiring employees from each department.
SELECT DISTINCT ON (emp_no) ut.emp_no,
	d.dept_name
INTO retiring_by_dept
FROM unique_titles as ut
	INNER JOIN dept_emp as de
		ON (ut.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no);

SELECT * FROM retiring_by_dept;

SELECT COUNT (emp_no) AS count2, dept_name
INTO retiring_by_dept_count
FROM retiring_by_dept
GROUP BY dept_name
ORDER BY dept_name;

SELECT * FROM retiring_by_dept_count;

-- Create a new table to hold the number of retirements from each department
-- and the number of eligible mentorship employees from each department.

SELECT m.dept_name,
	m.count1,
	r.count2
INTO employees_per_mentor
FROM mentorship_eligibility_dept as m
	INNER JOIN retiring_by_dept_count as r
		ON (m.dept_name = r.dept_name);

SELECT * FROM employees_per_mentor;

-- Create a table to hold the results.
SELECT CAST (count1 AS float)
FROM employees_per_mentor;

SELECT CAST (count2 AS float)
FROM employees_per_mentor;

SELECT count2 / count1 AS employees_per_mentor,
	dept_name
INTO employees_per_mentor_2
FROM employees_per_mentor

SELECT * FROM employees_per_mentor_2
