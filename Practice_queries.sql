
-- DATABASE ARCHITECTURE: TABLES CREATION & DATA INSERTION

-- 1. Create Departments Table
CREATE TABLE Departments8 (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL
);

-- 2. Create Employees Table
CREATE TABLE Employees8 (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE NOT NULL,
    manager_id INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments8(department_id),
    FOREIGN KEY (manager_id) REFERENCES Employees8(employee_id)
);

-- 3. Create Salaries Table
CREATE TABLE Salaries (
    salary_id INT PRIMARY KEY,
    employee_id INT,
    salary_amount DECIMAL(10, 2) NOT NULL,
    effective_date DATE NOT NULL,
    is_current BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (employee_id) REFERENCES Employees8(employee_id)
);

-- Insert Department Data
INSERT INTO Departments8 VALUES 
(1, 'Engineering', 'New York'),
(2, 'Sales', 'London'),
(3, 'Marketing', 'San Francisco'),
(4, 'Finance', 'New York'),
(5, 'HR', 'London');

-- Insert Employee Data
INSERT INTO Employees8 VALUES 
(101, 'John', 'Doe', 'john.doe@company.com', '2020-01-15', NULL, 1),
(102, 'Jane', 'Smith', 'jane.smith@company.com', '2020-03-20', 101, 1),
(103, 'Bob', 'Johnson', 'bob.johnson@company.com', '2021-06-01', 101, 1),
(104, 'Alice', 'Williams', 'alice.williams@company.com', '2019-11-12', NULL, 2),
(105, 'Charlie', 'Brown', 'charlie.brown@company.com', '2022-02-15', 104, 2),
(106, 'Eva', 'Davis', 'eva.davis@company.com', '2021-08-24', 104, 2),
(107, 'Frank', 'Miller', 'frank.miller@company.com', '2020-05-10', NULL, 3),
(108, 'Grace', 'Wilson', 'grace.wilson@company.com', '2023-01-10', 107, 3),
(109, 'Henry', 'Moore', 'henry.moore@company.com', '2018-04-01', NULL, 4),
(110, 'Ivy', 'Taylor', 'ivy.taylor@company.com', '2022-07-19', 109, 4),
(111, 'Jack', 'Anderson', 'jack.anderson@company.com', '2021-11-05', 109, 4),
(112, 'Karen', 'Thomas', 'karen.thomas@company.com', '2020-10-01', NULL, 5);

-- Insert Salary History Data
INSERT INTO Salaries VALUES 
(1, 101, 90000.00, '2020-01-15', FALSE),
(2, 101, 105000.00, '2022-01-15', TRUE),
(3, 102, 70000.00, '2020-03-20', FALSE),
(4, 102, 85000.00, '2022-03-20', TRUE),
(5, 103, 75000.00, '2021-06-01', TRUE),
(6, 104, 95000.00, '2019-11-12', FALSE),
(7, 104, 110000.00, '2022-11-12', TRUE),
(8, 105, 60000.00, '2022-02-15', TRUE),
(9, 106, 65000.00, '2021-08-24', TRUE),
(10, 107, 80000.00, '2020-05-10', TRUE),
(11, 108, 55000.00, '2023-01-10', TRUE),
(12, 109, 120000.00, '2018-04-01', FALSE),
(13, 109, 140000.00, '2022-04-01', TRUE),
(14, 110, 72000.00, '2022-07-19', TRUE),
(15, 111, 68000.00, '2021-11-05', TRUE),
(16, 112, 60000.00, '2020-10-01', TRUE);


-- SQL CORE CONCEPTS: 20 PRACTICE SCENARIOS SOLVED

-- Q1: Fetch full name and current salary of all employees
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    s.salary_amount 
FROM Employees8 e 
INNER JOIN Salaries s ON e.employee_id = s.employee_id 
WHERE s.is_current = 'TRUE';

-- Q2: List all employees who do not belong to any department
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_with_no_dept 
FROM Employees8 e 
LEFT JOIN Departments8 d ON e.department_id = d.department_id 
WHERE d.department_id IS NULL;

-- Q3: List departments that have more than 3 employees
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS total_employees
FROM Departments8 d 
INNER JOIN Employees8 e ON e.department_id = d.department_id 
GROUP BY d.department_name 
HAVING COUNT(e.employee_id) > 3;

-- Q4: Display all employees hired between January 1, 2020, and December 31, 2021
SELECT 
    CONCAT(first_name, ' ', last_name) AS employee_name, 
    hire_date 
FROM Employees8 
WHERE hire_date BETWEEN '2020-01-01' AND '2021-12-31';

-- Q5: Find the highest and lowest current salaries in the entire company
SELECT 
    MAX(salary_amount) AS highest_salary, 
    MIN(salary_amount) AS minimum_salary 
FROM Salaries 
WHERE is_current = 'TRUE';

-- Q6: List all the unique department names where locations are assigned
SELECT DISTINCT department_name 
FROM Departments8 
WHERE location IS NOT NULL;
-- Q7: Count how many employees report directly to each manager
SELECT 
    manager_id, 
    COUNT(employee_id) AS direct_reports_count 
FROM Employees8 
WHERE manager_id IS NOT NULL 
GROUP BY manager_id;

-- Q8: Departments along with the average current salary, sorted highest to lowest
SELECT 
    d.department_name, 
    AVG(s.salary_amount) AS average_salary 
FROM Departments8 d 
INNER JOIN Employees8 e ON d.department_id = e.department_id 
INNER JOIN Salaries s ON e.employee_id = s.employee_id 
WHERE s.is_current = 'TRUE' 
GROUP BY d.department_name 
ORDER BY average_salary DESC;

-- Q9: Find employees who have more than one salary record in the database
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COUNT(s.salary_id) AS salary_record_count
FROM Employees8 e 
INNER JOIN Salaries s ON e.employee_id = s.employee_id 
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(s.salary_id) > 1;

-- Q10: Fetch employees whose current salary is greater than the overall company average current salary
SELECT 
    employee_id,
    salary_amount 
FROM Salaries 
WHERE salary_amount > (
    SELECT AVG(salary_amount) FROM Salaries WHERE is_current = TRUE
) AND is_current = 'TRUE';

-- Q11: Extract usernames from employee emails (Text Manipulation)

SELECT 
    SPLIT_PART(email, '@', 1) AS user_name,
    email 
FROM Employees8;

-- Q12: Select the employees who earn the absolute maximum current salaries in their specific departments
-- My Initial Attempt (Logical Error: Grouping by employee name evaluates rows individually instead of aggregating by department):
-- select t.emp_name ,t.dep, max(t.s) from( SELECT concat(e.first_name,' ',e.last_name) emp_name, s.salary_amount s, d.department_name as dep from salaries s inner join Employees8 e 
--on e.employee_id = s.employee_id inner join Departments8 d on d.department_id=e.department_id)t group by t.dep,t.emp_name
-- Corrected Version (Optimized with CTE and Window Functions for proper compartmental grouping):
WITH ranked_salaries AS (
    SELECT 
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        d.department_name,
        s.salary_amount,
        DENSE_RANK() OVER(PARTITION BY d.department_id ORDER BY s.salary_amount DESC) AS rnk
    FROM Employees8 e
    INNER JOIN Departments8 d ON e.department_id = d.department_id
    INNER JOIN Salaries s ON e.employee_id = s.employee_id
    WHERE s.is_current = 'TRUE'
)
SELECT employee_name, department_name, salary_amount 
FROM ranked_salaries 
WHERE rnk = 1;

-- Q13: Find employees who have the same last name (Self-Join)
SELECT 
    CONCAT(e1.first_name, ' ', e1.last_name) AS full_name, 
    e1.last_name 
FROM Employees8 e1 
INNER JOIN Employees8 e2 ON e1.last_name = e2.last_name 
WHERE e1.employee_id <> e2.employee_id;

-- Q14: List the departments that have no employees assigned to them
SELECT 
    d.department_name 
FROM Departments8 d 
LEFT JOIN Employees8 e ON e.department_id = d.department_id 
WHERE e.employee_id IS NULL;

-- Q15: Show the employee_id, first name, and hire date of the oldest employee in the Engineering department
SELECT 
    e.employee_id,
    e.first_name,
    e.hire_date 
FROM Employees8 e 
INNER JOIN Departments8 d ON e.department_id = d.department_id 
WHERE d.department_name = 'Engineering' 
ORDER BY e.hire_date ASC 
LIMIT 1;

-- Q16: Select names of employees whose first name starts with 'J' and ends with 'N'
SELECT first_name 
FROM Employees8 
WHERE first_name ILIKE 'j%n';

-- Q17: Round current salaries to the nearest thousand
SELECT 
    employee_id,
    salary_amount,
    ROUND(salary_amount, -3) AS rounded_salary 
FROM Salaries 
WHERE is_current = 'TRUE';

-- Q18: Identify employees who work in a different department than their manager
-- My Initial Attempt (Logical Error: Joined on manager_id=manager_id which evaluates coworkers instead of worker-manager relationships):
-- select e1.employee_id , e2.manager_id , e1.department_id from Employees8 E1 INNER JOIN Employees8 E2 on
--e1.manager_id = e2.manager_id where e1.department_id <> e2.department_id
-- Corrected Version (Linked employee_id directly to manager_id for accurate reporting chain validation):
SELECT 
    e1.employee_id AS manager_id, 
    e1.department_id AS manager_dept,
    e2.employee_id AS employee_id,
    e2.department_id AS employee_dept
FROM Employees8 E1 
INNER JOIN Employees8 E2 ON e1.employee_id = e2.manager_id 
WHERE e1.department_id <> e2.department_id;

-- Q19: Dynamic categorization of employee experience levels using CASE WHEN logic
SELECT 
    CONCAT(first_name, ' ', last_name) AS employee_name, 
    hire_date, 
    EXTRACT(YEAR FROM hire_date) AS hire_year, 
    CASE 
        WHEN EXTRACT(YEAR FROM hire_date) < 2020 THEN 'Senior' 
        WHEN EXTRACT(YEAR FROM hire_date) = 2020 THEN 'Junior' 
        ELSE 'Intermediate/Other' 
    END AS Experience_Level 
FROM Employees8;

-- Q20: Rank employees within their respective departments based on current salary
select concat(e.first_name,' ', e.last_name) ,d.department_name, s.salary_amount ,
 DENSE_RANK() OVER(PARTITION BY d.department_name order by s.salary_amount desc ) 
 from Employees8 e inner join salaries s 
 on e.employee_id = s.employee_id inner join Departments8 as d on d.department_id=e.department_id 
 where s.is_current ='true'
