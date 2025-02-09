USE university;

CREATE TABLE Scholarship (
    ScholarshipID INT PRIMARY KEY,
    StudentID INT,
    IsFullOrPart CHAR(1),
    ScholarshipAmount DECIMAL(10, 2)
);

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    FullName NVARCHAR(200),
    DateOfBirth DATE,
    AdmissionYear INT,
    GroupID INT,
    ScholarshipID INT,
    Address NVARCHAR(200),
    FOREIGN KEY (GroupID) REFERENCES [Group](GroupID),
    FOREIGN KEY (ScholarshipID) REFERENCES Scholarship(ScholarshipID)
);

CREATE TABLE [Group] (
    GroupID INT PRIMARY KEY,
    GroupName NVARCHAR(200),
    FacultyID INT,
    SemesterNumber INT,
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID)
);

CREATE TABLE Faculty (
    FacultyID INT PRIMARY KEY,
    FacultyName NVARCHAR(200)
);

CREATE TABLE Subject (
    SubjectID INT PRIMARY KEY,
    SubjectName NVARCHAR(200),
    SubjectType NVARCHAR(200),
    GroupID INT,
    FOREIGN KEY (GroupID) REFERENCES [Group](GroupID)
);

CREATE TABLE Teacher (
    TeacherID INT PRIMARY KEY,
    FullName NVARCHAR(200),
    DepartmentID INT,
    Role NVARCHAR(200),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(200)
);

CREATE TABLE DepartmentFaculty (
    DepartmentFacultyID INT PRIMARY KEY,
    FacultyID INT,
    DepartmentID INT,
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE TeacherSubject (
    SemesterNumber INT,
    TeacherID INT,
    SubjectID INT,
    PRIMARY KEY (SemesterNumber, TeacherID, SubjectID),
    FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID)
);

CREATE TABLE StudentSubject (
    StudentSubjectID INT PRIMARY KEY,
    StudentID INT,
    SubjectID INT,
    SemesterNumber INT,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID)
);

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY,
    StudentSubjectID INT,
    Grade DECIMAL(3, 2),
    Date DATE,
    FOREIGN KEY (StudentSubjectID) REFERENCES StudentSubject(StudentSubjectID)
);


-- ���������� ������� Faculty
INSERT INTO Faculty (FacultyID, FacultyName) VALUES
(1, '�������������� ����������'),
(2, '�������������� ���������'),
(3, '���������� ���������'),
(4, '��������� ��������');
select * from Faculty;

-- ���������� ������� Group
INSERT INTO [Group] (GroupID, GroupName, FacultyID, SemesterNumber) VALUES
(1, '��-2022', 1, 3),
(2, '���-2022', 2, 3),
(3, '���-2022', 3, 3),
(4, '��-2022', 4, 3);
select * from [Group];

-- ���������� ������� Student
INSERT INTO Student (StudentID, FullName, DateOfBirth, AdmissionYear, GroupID, ScholarshipID, Address) VALUES
(1, '������ ���� ��������', '2004-03-15', 2022, 1, 1, '�����, ��. ������, 10'),
(2, '������ ���� ��������', '2004-07-22', 2022, 2, 2, '�����, ��. ���������, 15'),
(3, '������� ����� ���������', '2004-01-30', 2022, 3, NULL, '�����, ��. ������, 5'),
(4, '�������� ������� ����������', '2004-09-10', 2022, 4, 3, '�����, ��. �������������, 8');
select * from Student;

-- ���������� ������� Scholarship
INSERT INTO Scholarship (ScholarshipID, StudentID, IsFullOrPart, ScholarshipAmount) VALUES
(1, 1, 'F', 500.00),
(2, 2, 'P', 250.00),
(3, 4, 'F', 500.00);
select * from Scholarship;

-- ���������� ������� Subject
INSERT INTO Subject (SubjectID, SubjectName, SubjectType, GroupID) VALUES
(1, '����������', '������', 1),
(2, '������', '������������ �������', 2),
(3, '����������������', '��������', 3),
(4, '������� ��������', '������', 4);
select * from Subject;

-- ���������� ������� Teacher
INSERT INTO Teacher (TeacherID, FullName, DepartmentID, Role) VALUES
(1, '������� ����� ����������', 1, '���������'),
(2, '������� ���� ����������', 2, '������'),
(3, '�������� ����� ��������', 3, '���������'),
(4, '��������� �������� ���������', 4, '������� �������������');
select * from Teacher;

-- ���������� ������� Department
INSERT INTO Department (DepartmentID, DepartmentName) VALUES
(1, '������� ����������������'),
(2, '������� ����������'),
(3, '������� ������'),
(4, '������� ��������');
select * from Department;

-- ���������� ������� DepartmentFaculty
INSERT INTO DepartmentFaculty (DepartmentFacultyID, FacultyID, DepartmentID) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4);
select * from DepartmentFaculty;

-- ���������� ������� TeacherSubject
INSERT INTO TeacherSubject (SemesterNumber, TeacherID, SubjectID) VALUES
(3, 1, 1),
(3, 2, 2),
(3, 3, 3),
(3, 4, 4);
select * from TeacherSubject;

-- ���������� ������� StudentSubject
INSERT INTO StudentSubject (StudentSubjectID, StudentID, SubjectID, SemesterNumber) VALUES
(1, 1, 1, 3),
(2, 2, 2, 3),
(3, 3, 3, 3);
select * from StudentSubject;

-- ���������� ������� Grades
INSERT INTO Grades (GradeID, StudentSubjectID, Grade, Date) VALUES
(4, 1, 8.50, '2024-06-01'),
(5, 2, 7.00, '2024-06-01');
select * from Grades;


-- ������������������ ��� ��������� ����������� ScholarshipID:
CREATE SEQUENCE seq_scholarship_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- ������������������ ��� ��������� ����������� StudentID:
CREATE SEQUENCE seq_student_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- ������������������ ��� ��������� ����������� GroupID:
CREATE SEQUENCE seq_group_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- ������������������ ��� ��������� ����������� FacultyID:
CREATE SEQUENCE seq_faculty_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- ������������������ ��� ��������� ����������� SubjectID:
CREATE SEQUENCE seq_subject_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- ������������������ ��� ��������� ����������� TeacherID:
CREATE SEQUENCE seq_teacher_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- ������������������ ��� ��������� ����������� DepartmentID:
CREATE SEQUENCE seq_department_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- ������������������ ��� ��������� ����������� DepartmentFacultyID:
CREATE SEQUENCE seq_department_faculty_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- ������������������ ��� ��������� ����������� StudentSubjectID:
CREATE SEQUENCE seq_student_subject_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- ������������������ ��� ��������� ����������� GradeID:
CREATE SEQUENCE seq_grade_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- ������ �� ������� Student �� ���� GroupID:
CREATE INDEX idx_student_group ON Student(GroupID);

-- ������ �� ������� Grades �� ���� StudentSubjectID:
CREATE INDEX idx_grades_student_subject ON Grades(StudentSubjectID);

-- ������ �� ������� Subject �� ���� GroupID:
CREATE INDEX idx_subject_group ON Subject(GroupID);

-- ������ �� ������� Teacher �� ���� DepartmentID:
CREATE INDEX idx_teacher_department ON Teacher(DepartmentID);

-- ������ �� ������� Subject �� ���� SubjectName:
CREATE INDEX idx_subject_name ON Subject(SubjectName);

-- ������ �� ������� Department �� ���� DepartmentName:
CREATE INDEX idx_department_name ON Department(DepartmentName);

GO
-- ������������� ��� ��������� ������ ��������� � �� �������� � ����������:
CREATE or ALTER VIEW vw_student_subjects AS
SELECT 
    s.StudentID as [ID ��������],
    s.FullName as [���],
    g.GroupName as [�������� ������],
    sub.SubjectName as [�������� ��������]
FROM 
    Student s
JOIN 
    [Group] g ON s.GroupID = g.GroupID
JOIN 
    StudentSubject ss ON s.StudentID = ss.StudentID
JOIN 
    Subject sub ON ss.SubjectID = sub.SubjectID;
GO

SELECT * FROM vw_student_subjects;

GO
-- ������������� ��� ��������� ���������� � ��������� � �� ����������:
CREATE OR ALTER VIEW vw_student_scholarship AS
SELECT 
    s.StudentID AS [������������� ��������],
    s.FullName AS [���],
    s.DateOfBirth AS [���� ��������],
    s.AdmissionYear AS [��� �����������],
    s.Address AS [�����],
    sch.ScholarshipAmount AS [����� ���������],
    sch.IsFullOrPart AS [��� ���������]
FROM 
    Student s
LEFT JOIN 
    Scholarship sch ON s.ScholarshipID = sch.ScholarshipID;
GO

SELECT * FROM vw_student_scholarship;

GO
-- ������������� ��� ������� ������������ ���������:
CREATE OR ALTER VIEW vw_student_performance AS
SELECT 
    s.StudentID AS [������������� ��������],
    s.FullName AS [���],
    AVG(g.Grade) AS [������� ������]
FROM 
    Student s
JOIN 
    StudentSubject ss ON s.StudentID = ss.StudentID
JOIN 
    Grades g ON ss.StudentSubjectID = g.StudentSubjectID
GROUP BY 
    s.StudentID, s.FullName;
GO

SELECT * FROM vw_student_performance;

GO

-- ��������� ���������� ���������
GO
CREATE OR ALTER PROCEDURE AddStudent
    @FullName NVARCHAR(200),
    @DateOfBirth DATE,
    @AdmissionYear INT,
    @GroupID INT,
	@ScholarshipID INT,
    @Address NVARCHAR(200)
AS
BEGIN
    DECLARE @NewStudentID INT;
    
    SET @NewStudentID = NEXT VALUE FOR seq_student_id;

    INSERT INTO Student (StudentID, FullName, DateOfBirth, AdmissionYear, GroupID, ScholarshipID, Address)
    VALUES (@NewStudentID, @FullName, @DateOfBirth, @AdmissionYear, @GroupID, @ScholarshipID, @Address);
END;

EXEC AddStudent 
    @FullName = '����� ������ ������������', 
    @DateOfBirth = '2004-09-10', 
    @AdmissionYear = 2023, 
    @GroupID = 1, 
	@ScholarshipID = 2,
    @Address = '����� �����������, ��� 2';

SELECT * FROM Student;

-- ��������� ��� �������� ��������:
GO
CREATE OR ALTER PROCEDURE DeleteStudent
    @StudentID INT
AS
BEGIN
    DELETE FROM Student WHERE StudentID = @StudentID;
END;


EXEC DeleteStudent @StudentID = 6;

SELECT * FROM Student;

GO
-- ��������� ��� ���������� ��������:
CREATE OR ALTER PROCEDURE AddSubject
    @SubjectName NVARCHAR(200),
    @SubjectType NVARCHAR(200),
    @GroupID INT
AS
BEGIN
    DECLARE @NewSubjectID INT;

    SET @NewSubjectID = NEXT VALUE FOR seq_subject_id;

    INSERT INTO Subject (SubjectID, SubjectName, SubjectType, GroupID)
    VALUES (@NewSubjectID, @SubjectName, @SubjectType, @GroupID);
END;


EXEC AddSubject 
    @SubjectName = '������� ��������', 
    @SubjectType = '������', 
    @GroupID = 4;

SELECT * FROM Subject;

GO

-- ��������� ��� �������� ��������:
CREATE OR ALTER PROCEDURE DeleteSubject
    @SubjectID INT
AS
BEGIN
    DELETE FROM Subject WHERE SubjectID = @SubjectID;
END;


EXEC DeleteSubject @SubjectID = 4;

SELECT * FROM Subject;

GO
-- ��������� ��� ���������� �������������:
CREATE OR ALTER PROCEDURE AddTeacher
    @FullName NVARCHAR(200),
    @DepartmentID INT,
    @Role NVARCHAR(200)
AS
BEGIN
    DECLARE @NewTeacherID INT;

    SET @NewTeacherID = NEXT VALUE FOR seq_teacher_id;

    INSERT INTO Teacher (TeacherID, FullName, DepartmentID, Role)
    VALUES (@NewTeacherID, @FullName, @DepartmentID, @Role);
END;

EXEC AddTeacher 
    @FullName = '������� ����� ����������', 
    @DepartmentID = 2, 
    @Role = '������� �������������';

select * from Teacher;

GO
-- ��������� ��� �������� �������������
CREATE OR ALTER PROCEDURE DeleteTeacher
    @TeacherID INT
AS
BEGIN
    DELETE FROM Teacher WHERE TeacherID = @TeacherID;
END;

SELECT * FROM Teacher;

EXEC DeleteTeacher @TeacherID = 5; 


GO
-- ��������� ��� ���������� ����� ������ ��������:
CREATE or ALTER PROCEDURE AddStudentGrade
    @StudentSubjectID INT,
    @Grade DECIMAL(3, 2),
    @Date DATE
AS
BEGIN
    DECLARE @NewGradeID INT;

    SET @NewGradeID = NEXT VALUE FOR seq_grade_id;

    INSERT INTO Grades (GradeID, StudentSubjectID, Grade, Date)
    VALUES (@NewGradeID, @StudentSubjectID, @Grade, @Date);
END;

EXEC AddStudentGrade @StudentSubjectID = 2, @Grade = 8, @Date = '2024-10-20';
SELECT * FROM Grades;

GO
-- ��������� ��� ���������� ������ ��������:
CREATE PROCEDURE UpdateStudentGrade
    @GradeID INT,
    @NewGrade DECIMAL(3, 2)
AS
BEGIN
    UPDATE Grades
    SET Grade = @NewGrade
    WHERE GradeID = @GradeID;
END;

EXEC UpdateStudentGrade @GradeID = 2, @NewGrade = 5.00;
SELECT * FROM Grades;


GO
-- ��������� ��� �������� ������ ��������:
CREATE PROCEDURE DeleteStudentGrade
    @GradeID INT
AS
BEGIN
    DELETE FROM Grades
    WHERE GradeID = @GradeID;
END;

EXEC DeleteStudentGrade @GradeID = 8;
SELECT * FROM Grades;


GO
-- ��������� ��� ��������� ������� ������ ��������:
CREATE OR ALTER PROCEDURE GetStudentAverageGrade
    @StudentID INT
AS
BEGIN
    SELECT AVG(g.Grade) AS [�������������]
    FROM Grades g
    JOIN StudentSubject ss ON g.StudentSubjectID = ss.StudentSubjectID
    WHERE ss.StudentID = @StudentID;
END;

EXEC GetStudentAverageGrade @StudentID = 1;

GO
-- ��������� ��� ��������� ���������� � ������������� �� ��� ID:
CREATE or ALTER PROCEDURE GetTeacherInfo
    @TeacherID INT
AS
BEGIN
    SELECT 
        t.FullName AS [���],
        d.DepartmentName AS [�������� �������],
        t.Role AS [���������]
    FROM 
        Teacher t
    JOIN 
        Department d ON t.DepartmentID = d.DepartmentID
    WHERE 
        t.TeacherID = @TeacherID;
END;

EXEC GetTeacherInfo @TeacherID = 1;


GO
-- ��������� ��� ��������� ���� ��������� � �� �����������:
CREATE or ALTER PROCEDURE GetStudentsWithScholarships
AS
BEGIN
    SELECT 
        s.StudentID AS [������������� ��������],
        s.FullName AS [���],
        sc.ScholarshipAmount AS [����� ���������],
        sc.IsFullOrPart AS [��� ���������]
    FROM 
        Student s
    LEFT JOIN 
        Scholarship sc ON s.StudentID = sc.StudentID;
END;

EXEC GetStudentsWithScholarships;

GO
-- ������� ��� ��������� ���������� ��������� � ������:
CREATE OR ALTER FUNCTION GetStudentCountInGroup
(
    @GroupID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @StudentCount INT;

    SELECT @StudentCount = COUNT(*)
    FROM Student
    WHERE GroupID = @GroupID;

    RETURN @StudentCount;
END;

GO
SELECT dbo.GetStudentCountInGroup(1) AS [���������� c��������];

GO
-- ��������� ������� ������ �� ��������
CREATE OR ALTER FUNCTION GetAverageGradeBySubject
(
    @SubjectID INT
)
RETURNS DECIMAL(3, 2)
AS
BEGIN
    DECLARE @AverageGrade DECIMAL(3, 2);

    SELECT @AverageGrade = AVG(g.Grade)
    FROM Grades g
    JOIN StudentSubject ss ON g.StudentSubjectID = ss.StudentSubjectID
    WHERE ss.SubjectID = @SubjectID;

    RETURN @AverageGrade;
END;
GO
SELECT dbo.GetAverageGradeBySubject(1) AS [������� ������ �� ��������];


GO
-- ������� ��� ���������� ������� ��������� ��� ��������� ������������ ��������:
CREATE OR ALTER TRIGGER trg_UpdateScholarshipStatus
ON Grades
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @StudentID INT;
    DECLARE @AverageGrade DECIMAL(3, 2);
    DECLARE @ScholarshipAmount DECIMAL(10, 2);

    DECLARE student_cursor CURSOR FOR 
    SELECT DISTINCT ss.StudentID
    FROM INSERTED i
    JOIN StudentSubject ss ON i.StudentSubjectID = ss.StudentSubjectID;

    OPEN student_cursor;
    FETCH NEXT FROM student_cursor INTO @StudentID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @AverageGrade = AVG(g.Grade)
        FROM Grades g
        JOIN StudentSubject ss ON g.StudentSubjectID = ss.StudentSubjectID
        WHERE ss.StudentID = @StudentID;

        IF @AverageGrade >= 5 AND @AverageGrade < 6
            SET @ScholarshipAmount = 200;
        ELSE IF @AverageGrade >= 6 AND @AverageGrade < 7
            SET @ScholarshipAmount = 300;
        ELSE IF @AverageGrade >= 7 AND @AverageGrade < 8
            SET @ScholarshipAmount = 400;
        ELSE IF @AverageGrade >= 8 AND @AverageGrade < 9
            SET @ScholarshipAmount = 500;
        ELSE IF @AverageGrade >= 9
            SET @ScholarshipAmount = 600;
        ELSE
            SET @ScholarshipAmount = 0;

        UPDATE Scholarship
        SET ScholarshipAmount = @ScholarshipAmount, 
            IsFullOrPart = CASE 
                WHEN @AverageGrade >= 4.0 THEN 'F' 
                ELSE 'P' 
            END
        WHERE StudentID = @StudentID;

        FETCH NEXT FROM student_cursor INTO @StudentID;
    END

    CLOSE student_cursor;
    DEALLOCATE student_cursor;
END;


EXEC GetStudentsWithScholarships;

EXEC UpdateStudentGrade @GradeID = 2, @NewGrade = 3.00;

SELECT * FROM vw_student_performance;


GO
-- ������� ��� �������� ������� � ������������� �� ��������� ������
CREATE TRIGGER trg_DeleteTeacher
ON Teacher
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @TeacherID INT;

    SELECT @TeacherID = deleted.TeacherID
    FROM deleted;

    DELETE FROM TeacherSubject WHERE TeacherID = @TeacherID;

    DELETE FROM Teacher WHERE TeacherID = @TeacherID;
END;

GO
-- ������� ��� �������� ������ � �������� �� ��������� ������
CREATE or ALTER TRIGGER trg_DeleteStudent
ON Student
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @StudentID INT;

    SELECT @StudentID = deleted.StudentID
    FROM deleted;

    BEGIN TRANSACTION;

    BEGIN TRY
        DELETE FROM Grades
        WHERE StudentSubjectID IN (
            SELECT StudentSubjectID 
            FROM StudentSubject 
            WHERE StudentID = @StudentID
        );

        DELETE FROM StudentSubject
        WHERE StudentID = @StudentID;

        DELETE FROM Student
        WHERE StudentID = @StudentID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;


GO
-- ������� ��� �������� ������ � �������� �� ��������� ������
CREATE or ALTER TRIGGER trg_DeleteSubject
ON Subject
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @SubjectID INT;

    SELECT @SubjectID = deleted.SubjectID
    FROM deleted;

    BEGIN TRANSACTION;

    BEGIN TRY
        DELETE FROM Grades
        WHERE StudentSubjectID IN (
            SELECT StudentSubjectID 
            FROM StudentSubject 
            WHERE SubjectID = @SubjectID
        );

        DELETE FROM StudentSubject
        WHERE SubjectID = @SubjectID;

        DELETE FROM TeacherSubject
        WHERE SubjectID = @SubjectID;

        DELETE FROM Subject
        WHERE SubjectID = @SubjectID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
