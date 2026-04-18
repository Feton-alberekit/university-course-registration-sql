# university-course-registration-sql
A relational database system for managing university course registration using SQL and EER modeling.
# 🎓 University Course Registration System
 
A relational database project designed and implemented for managing a university's course registration process. Built using **Oracle SQL**, the system covers the full lifecycle of academic data — from student enrollment to instructor assignments and grade tracking.
 
---
 
## 📋 Table of Contents
 
- [Overview](#overview)
- [Database Schema](#database-schema)
- [Entity Relationship (EER) Diagram](#entity-relationship-eer-diagram)
- [Mapping Steps](#mapping-steps)
- [Tables](#tables)
- [Sample Data](#sample-data)
- [Queries](#queries)
- [How to Run](#how-to-run)
---
 
## Overview
 
This project implements a **Database Management System (DBMS)** for a university course registration process. The core entities are:
 
- **Student** — undergraduate, master's, and PhD students
- **Instructor** — assistant professors, professors, and lecturers
- **Course** — offered by specific departments
- **Department** — belonging to a college of computer science
- **Semester** — Fall, Spring, and Summer terms
- **Enrollment** — linking students to courses with grades and status
The system addresses common manual-process issues such as data integrity violations, difficulty generating reports, and poor access control.
 
---
 
## Database Schema
 
The relational schema includes **13 tables**:
 
| Table | Description |
|---|---|
| `PERSON` | Superclass for all people (students & instructors) |
| `STUDENT` | Student-specific attributes |
| `UNDER_GRADUATE` | Undergraduate subtype with level |
| `MASTER` | Master's student subtype with program focus |
| `PHD` | PhD student subtype with research area |
| `INSTRUCTOR` | Instructor attributes including rank and contract type |
| `COURSE` | Courses offered by departments |
| `DEPARTMENT` | Academic departments |
| `COLLEGE_OF_CS` | College locations |
| `SEMESTER` | Academic semesters and date ranges |
| `ENROLLMENT` | Student enrollment records with grades |
| `OFFERED_IN` | M:N relationship — courses offered in semesters |
| `TEACHES` | M:N relationship — instructors teaching courses |
 
---
 
## Entity Relationship (EER) Diagram
 
The EER diagram models:
 
- **Specialization/Generalization** — `PERSON` → `STUDENT` / `INSTRUCTOR` (disjoint, using Method 8A)
- **Degree-level specialization** — `STUDENT` → `UNDER_GRADUATE` / `MASTER` / `PHD` (disjoint)
- **Rank specialization** — `INSTRUCTOR` → Assistant Professor / Professor / Lecturer (using Method 8C, with `Rank` as the type attribute)
- **M:N Relationships** — `TEACHES` and `OFFERED_IN`
- **1:N Relationships** — Department → Course, Department → Student, College → Department, etc.
---
 
## Mapping Steps
 
### Step 1 — Regular Entities
Strong entities mapped with all simple attributes and primary keys:
`PERSON`, `DEPARTMENT`, `COURSE`, `SEMESTER`, `COLLEGE_OF_CS`, `ENROLLMENT`
 
### Step 4 — 1:N Relationships
Foreign keys added to the "many" side:
- `DeptID` → `COURSE`, `STUDENT`, `INSTRUCTOR`
- `CollegeID` → `DEPARTMENT`
- `CourseID`, `SemesterID`, `Sssn` → `ENROLLMENT`
### Step 5 — M:N Relationships
Junction tables created:
- `TEACHES (Issn, CourseID)`
- `OFFERED_IN (CourseID, SemesterID)`
### Step 8 — Specialization / Generalization
- **Method 8A** — Separate subclass tables for `STUDENT` and `INSTRUCTOR`, each referencing `PERSON` via FK
- **Method 8C** — Single `INSTRUCTOR` table with a `Rank` type attribute for rank specialization
---
 
## Tables
 
### PERSON
```sql
CREATE TABLE PERSON (
    Ssn   VARCHAR2(10) CONSTRAINT Ssn_PK PRIMARY KEY,
    Fname VARCHAR2(30) NOT NULL,
    Lname VARCHAR2(30) NOT NULL,
    Email VARCHAR2(100) CONSTRAINT Email_UQ UNIQUE,
    Phone VARCHAR2(20)  CONSTRAINT Phone_UQ UNIQUE
);
```
 
### STUDENT
```sql
CREATE TABLE STUDENT (
    Sssn           VARCHAR2(10) CONSTRAINT Sssn_PK PRIMARY KEY,
    Gendar         VARCHAR2(10),
    Address        VARCHAR2(100),
    Admission_Year NUMBER(4),
    DeptID         NUMBER(10) NOT NULL,
    CONSTRAINT Sssn_FK   FOREIGN KEY (Sssn)   REFERENCES PERSON(Ssn),
    CONSTRAINT DeptID_FK FOREIGN KEY (DeptID) REFERENCES DEPARTMENT(DeptID)
);
```
 
### INSTRUCTOR
```sql
CREATE TABLE INSTRUCTOR (
    Issn                  VARCHAR2(10) CONSTRAINT Issn_PK PRIMARY KEY,
    Office                VARCHAR2(50),
    DeptID                NUMBER(10) NOT NULL,
    Rank                  VARCHAR2(50),
    Experience_Years      NUMBER(2),
    Contract_Type         VARCHAR2(50),
    Promotion_Eligibility VARCHAR2(10),
    CONSTRAINT Dept_FK FOREIGN KEY (DeptID) REFERENCES DEPARTMENT(DeptID)
);
```
 
### ENROLLMENT
```sql
CREATE TABLE ENROLLMENT (
    EnrollmentID    NUMBER(10) CONSTRAINT EnrollmentID_PK PRIMARY KEY,
    Status          VARCHAR2(20),
    Enrollment_Date DATE,
    Grade_Value     VARCHAR2(5),
    Sssn            VARCHAR2(10) NOT NULL,
    CourseID        NUMBER(10)   NOT NULL,
    SemesterID      NUMBER(10)   NOT NULL,
    CONSTRAINT ESssn_FK       FOREIGN KEY (Sssn)       REFERENCES STUDENT(Sssn),
    CONSTRAINT ECourseID_FK   FOREIGN KEY (CourseID)   REFERENCES COURSE(CourseID),
    CONSTRAINT ESemesterID_FK FOREIGN KEY (SemesterID) REFERENCES SEMESTER(SemesterID)
);
```
 
> See the full SQL file for all table definitions.
 
---
 
## Sample Data
 
The database is pre-populated with:
 
- **15 persons** (10 students + 5 instructors)
- **4 college locations** — Jeddah, Rabigh, Khulais, Al-Kamil
- **5 departments** — Computer Science, Information Systems, Software Engineering, Information Technology, Cyber Security
- **4 semesters** — Fall 2024, Spring 2025, Summer 2025, Fall 2025
- **5 courses** — Programming I, Database Systems, Software Design, Network Fundamentals, Cyber Defense
- **10 enrollment records** with statuses Active / Completed and grades A, B, C
---
 
## Queries
 
The project includes **30+ SQL queries** organized into the following categories:
 
### 🔍 Filter Queries
- Students by city (Jeddah, Rabigh, Khulais, Al-Kamil)
- Students by gender
- Courses by credit hours
- Active / Completed enrollments
- Full-time / Part-time instructors
- Grades A, B, C
- Semesters by year
### 🔗 Join Queries
- Students with their department and college location
- Instructors with courses they teach and department
- All courses with instructor full name and rank
- Student enrollment history (name, course, semester, grade)
- Students who are NOT undergraduate (LEFT JOIN + IS NULL)
- Students who achieved grade A with course name
### 📊 Aggregate / GROUP BY Queries
- Number of students per department
- Number of courses per department
- Number of instructors per department
- Enrollments per course per semester (Fall 2024, Spring 2025, Summer 2025)
- Courses offered per semester
- Grade distribution (completed enrollments only)
- Student count by gender
### 🔃 ORDER BY Queries
- Students sorted by admission year (ASC) and last name (DESC)
- Courses sorted by credits (DESC) then name (ASC)
- Instructors sorted by experience years (DESC)
- Enrollments sorted by date (newest first)
- Departments sorted alphabetically
### Example — Student Full Academic Report
```sql
SELECT p.Fname, p.Lname, c.Course_Name, se.Term, e.Grade_Value
FROM ENROLLMENT e
JOIN STUDENT  s  ON e.Sssn       = s.Sssn
JOIN PERSON   p  ON s.Sssn       = p.Ssn
JOIN COURSE   c  ON e.CourseID   = c.CourseID
JOIN SEMESTER se ON e.SemesterID = se.SemesterID;
```
 
### Example — Instructor Workload
```sql
SELECT i.Issn, i.Rank, c.Course_Name, d.Dept_Name
FROM INSTRUCTOR i
JOIN TEACHES    t ON i.Issn     = t.Issn
JOIN COURSE     c ON t.CourseID = c.CourseID
JOIN DEPARTMENT d ON c.DeptID   = d.DeptID;
```
 
---
 
## How to Run
 
1. **Requirements** — Oracle SQL Developer (or any Oracle-compatible SQL client)
2. **Execution order** — Run the SQL file sections in this order to avoid FK constraint errors:
   1. `CREATE TABLE` statements
   2. `INSERT INTO PERSON` statements
   3. `INSERT INTO COLLEGE_OF_CS` statements
   4. `INSERT INTO DEPARTMENT` statements
   5. `INSERT INTO SEMESTER` statements
   6. `INSERT INTO COURSE` statements
   7. `INSERT INTO STUDENT` (and subtypes: `UNDER_GRADUATE`, `MASTER`, `PHD`)
   8. `INSERT INTO INSTRUCTOR` statements
   9. `INSERT INTO OFFERED_IN` and `TEACHES`
   10. `INSERT INTO ENROLLMENT` statements
   11. Run `SELECT` queries
3. **All queries** can be executed independently after data is loaded.
---
 
## Project Structure
 
```
university-course-registration/
│
├── README.md                  ← This file
├── sql/
│   ├── create_tables.sql      ← DDL: all CREATE TABLE statements
│   ├── insert_data.sql        ← DML: all INSERT statements
│   └── queries.sql            ← All SELECT queries
└── docs/
    ├── EER_Diagram.png        ← Entity-relationship diagram
    └── Relational_Schema.png  ← Relational schema diagram
```
 
---
 
## Key Design Decisions
 
- **PERSON as superclass** — avoids redundant name/email/phone columns across student and instructor tables
- **Disjoint specialization for students** — a student belongs to exactly one degree level (UG, Master, PhD)
- **Rank stored as attribute** — instructor rank variants (Assistant Professor, Professor, Lecturer) use Method 8C to keep the table compact
- **ENROLLMENT as a ternary-like table** — connects student, course, and semester in a single record with grade and status metadata
- **OFFERED_IN separate from ENROLLMENT** — cleanly separates course scheduling from actual student registration
---
 
