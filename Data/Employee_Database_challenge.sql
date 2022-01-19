-- Number of retiring employees by title
SELECT em.emp_no,
	em.first_name,
	em.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
from employees as em
INNER JOIN titles_two as ti
ON (em.emp_no = ti.emp_no)
WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY em.emp_no;

-- Note, I created a VBA code to remove duplicate titles and keep
-- the more recent position. 
SELECT em.emp_no,
	em.first_name,
	em.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
--INTO unique_titles
from employees as em
INNER JOIN titles as ti
ON (em.emp_no = ti.emp_no)
INNER JOIN dept_emp as de
ON (em.emp_no = de.emp_no)
WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY em.emp_no, ti.to_date desc;
--So my code didn't quite work, since the newer titles
--were not always listed second in the original .csv file.

--Uploaded the uneditted titles.csv
CREATE TABLE titles_two(
	emp_no INT NOT NULL,
	title TEXT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

--Create a list of current employees with their most recent titles.
SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM retirement_titles 
WHERE (to_date = '1999-01-01')
ORDER BY emp_no, to_date DESC;

-- Count the number of retiring employees by title.
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count desc;


--Create a list of employees who are eligible to mentor new hires.
SELECT DISTINCT ON (em.emp_no) em.emp_no,
	em.first_name,
	em.last_name,
	em.birth_date, 
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibility
from employees as em
INNER JOIN dept_emp as de
on (em.emp_no = de.emp_no)
INNER JOIN titles as ti
ON (em.emp_no = ti.emp_no)
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY em.emp_no;


