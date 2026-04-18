-- NOTE:
-- Make sure to run create_tables.sql and queries.sql before running this file
-- ============================================
-- STUDENT LOCATION QUERIES
-- ============================================

-- Retrieve students (name + email) who live in Jeddah
SELECT p.Fname, p.Lname, p.Email
FROM PERSON p
JOIN STUDENT s ON p.Ssn = s.Sssn
WHERE s.Address = 'Jeddah';

-- Retrieve students who live in Al-Kamil
SELECT p.Fname, p.Lname, p.Email
FROM PERSON p
JOIN STUDENT s ON p.Ssn = s.Sssn
WHERE s.Address = 'Al-Kamil';

-- Retrieve students who live in Rabigh
SELECT p.Fname, p.Lname, p.Email
FROM PERSON p
JOIN STUDENT s ON p.Ssn = s.Sssn
WHERE s.Address = 'Rabigh';

-- Retrieve students who live in Khulais
SELECT p.Fname, p.Lname, p.Email
FROM PERSON p
JOIN STUDENT s ON p.Ssn = s.Sssn
WHERE s.Address = 'Khulais';


-- ============================================
-- COURSE FILTERING
-- ============================================

-- Retrieve all courses with 3 credits
SELECT CourseID, Course_Name, Credits
FROM COURSE
WHERE Credits = 3;


-- ============================================
-- ENROLLMENT STATUS
-- ============================================

-- Retrieve active enrollments
SELECT EnrollmentID, Status, Enrollment_Date, Sssn, CourseID, SemesterID
FROM ENROLLMENT
WHERE Status = 'Active';

-- Retrieve completed enrollments
SELECT EnrollmentID, Status, Enrollment_Date, Sssn, CourseID, SemesterID
FROM ENROLLMENT
WHERE Status = 'Completed';


-- ============================================
-- STUDENT DEMOGRAPHICS
-- ============================================

-- Retrieve male students with their department
SELECT p.Fname, p.Lname, s.Gendar, d.Dept_Name
FROM STUDENT s
JOIN PERSON p   ON s.Sssn  = p.Ssn
JOIN DEPARTMENT d ON s.DeptID = d.DeptID
WHERE s.Gendar = 'Male';

-- Retrieve female students with their department
SELECT p.Fname, p.Lname, s.Gendar, d.Dept_Name
FROM STUDENT s
JOIN PERSON p   ON s.Sssn  = p.Ssn
JOIN DEPARTMENT d ON s.DeptID = d.DeptID
WHERE s.Gendar = 'Female';


-- ============================================
-- COURSES BY DEPARTMENT
-- ============================================

-- Retrieve courses offered by each department
SELECT c.CourseID, c.Course_Name, d.Dept_Name
FROM COURSE c
JOIN DEPARTMENT d ON c.DeptID = d.DeptID
WHERE d.Dept_Name = 'Computer Science';

-- Repeat for other departments (IS, SE, IT, Cyber Security)


-- ============================================
-- INSTRUCTOR FILTERING
-- ============================================

-- Retrieve full-time instructors
SELECT Issn, Rank, Office, Experience_Years
FROM INSTRUCTOR
WHERE Contract_Type = 'Full-Time';

-- Retrieve part-time instructors
SELECT Issn, Rank, Office, Experience_Years
FROM INSTRUCTOR
WHERE Contract_Type = 'Part-Time';


-- ============================================
-- GRADE ANALYSIS
-- ============================================

-- Retrieve completed enrollments with grade A
SELECT EnrollmentID, Sssn, CourseID, Grade_Value
FROM ENROLLMENT
WHERE Status = 'Completed'
  AND Grade_Value = 'A';

-- Repeat for grades B and C


-- ============================================
-- SEMESTER FILTERING
-- ============================================

-- Retrieve semesters starting in 2025
SELECT SemesterID, Term, Start_Date, End_Date
FROM SEMESTER
WHERE EXTRACT(YEAR FROM Start_Date) = 2025;

-- Retrieve semesters starting in 2024
SELECT SemesterID, Term, Start_Date, End_Date
FROM SEMESTER
WHERE EXTRACT(YEAR FROM Start_Date) = 2024;


-- ============================================
-- AGGREGATION QUERIES
-- ============================================

-- Count number of students in each department
SELECT d.Dept_Name,
       COUNT(*) AS Number_Of_Students
FROM STUDENT s
JOIN DEPARTMENT d ON s.DeptID = d.DeptID
GROUP BY d.Dept_Name;

-- Count enrollments per course in a specific term
SELECT c.Course_Name,
       COUNT(*) AS Num_Enrollments
FROM ENROLLMENT e
JOIN COURSE c   ON e.CourseID   = c.CourseID
JOIN SEMESTER se ON e.SemesterID = se.SemesterID
WHERE se.Term = 'Fall 2024'
GROUP BY c.Course_Name
HAVING COUNT(*) > 1;


-- ============================================
-- SORTING
-- ============================================

-- Sort students by admission year and last name
SELECT p.Fname,
       p.Lname,
       s.Admission_Year
FROM STUDENT s
JOIN PERSON p ON s.Sssn = p.Ssn
ORDER BY s.Admission_Year ASC, p.Lname DESC;

-- Sort courses by credits (descending)
SELECT CourseID, Course_Name, Credits
FROM COURSE
ORDER BY Credits DESC, Course_Name ASC;


-- ============================================
-- COMPLEX JOINS
-- ============================================

-- Retrieve student + course + semester + grade
SELECT p.Fname,
       p.Lname,
       c.Course_Name,
       se.Term,
       e.Grade_Value
FROM ENROLLMENT e
JOIN STUDENT   s  ON e.Sssn       = s.Sssn
JOIN PERSON    p  ON s.Sssn       = p.Ssn
JOIN COURSE    c  ON e.CourseID   = c.CourseID
JOIN SEMESTER  se ON e.SemesterID = se.SemesterID;


-- Retrieve instructor with courses and department
SELECT i.Issn,
       i.Rank,
       c.Course_Name,
       d.Dept_Name
FROM INSTRUCTOR i
JOIN TEACHES   t ON i.Issn      = t.Issn
JOIN COURSE    c ON t.CourseID  = c.CourseID
JOIN DEPARTMENT d ON c.DeptID   = d.DeptID;


-- ============================================
-- ADVANCED QUERIES
-- ============================================

-- Retrieve students who achieved grade A
SELECT p.Fname, p.Lname, c.Course_Name, e.Grade_Value
FROM ENROLLMENT e
JOIN STUDENT s ON e.Sssn = s.Sssn
JOIN PERSON p ON s.Sssn = p.Ssn
JOIN COURSE c ON e.CourseID = c.CourseID
WHERE e.Grade_Value = 'A';

-- Retrieve students who are NOT undergraduate
SELECT p.Fname, p.Lname
FROM STUDENT s
JOIN PERSON p ON s.Sssn = p.Ssn
LEFT JOIN UNDER_GRADUATE u ON s.Sssn = u.Sssn
WHERE u.Sssn IS NULL;

-- Count instructors per department
SELECT d.Dept_Name, COUNT(i.Issn) AS Num_Instructors
FROM DEPARTMENT d
LEFT JOIN INSTRUCTOR i ON d.DeptID = i.DeptID
GROUP BY d.Dept_Name;