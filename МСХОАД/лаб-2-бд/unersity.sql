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


-- Заполнение таблицы Faculty
INSERT INTO Faculty (FacultyID, FacultyName) VALUES
(1, 'Информационные технологии'),
(2, 'Математический факультет'),
(3, 'Физический факультет'),
(4, 'Факультет искусств');
select * from Faculty;

-- Заполнение таблицы Group
INSERT INTO [Group] (GroupID, GroupName, FacultyID, SemesterNumber) VALUES
(1, 'ИТ-2022', 1, 3),
(2, 'МАТ-2022', 2, 3),
(3, 'ФИЗ-2022', 3, 3),
(4, 'ИС-2022', 4, 3);
select * from [Group];

-- Заполнение таблицы Student
INSERT INTO Student (StudentID, FullName, DateOfBirth, AdmissionYear, GroupID, ScholarshipID, Address) VALUES
(1, 'Иванов Иван Иванович', '2004-03-15', 2022, 1, 1, 'Минск, ул. Ленина, 10'),
(2, 'Петров Петр Петрович', '2004-07-22', 2022, 2, 2, 'Минск, ул. Советская, 15'),
(3, 'Сидоров Сидор Сидорович', '2004-01-30', 2022, 3, NULL, 'Минск, ул. Победы, 5'),
(4, 'Алексеев Алексей Алексеевич', '2004-09-10', 2022, 4, 3, 'Минск, ул. Кальварийская, 8');
select * from Student;

-- Заполнение таблицы Scholarship
INSERT INTO Scholarship (ScholarshipID, StudentID, IsFullOrPart, ScholarshipAmount) VALUES
(1, 1, 'F', 500.00),
(2, 2, 'P', 250.00),
(3, 4, 'F', 500.00);
select * from Scholarship;

-- Заполнение таблицы Subject
INSERT INTO Subject (SubjectID, SubjectName, SubjectType, GroupID) VALUES
(1, 'Математика', 'Лекции', 1),
(2, 'Физика', 'Практические занятия', 2),
(3, 'Программирование', 'Семинары', 3),
(4, 'История искусств', 'Лекции', 4);
select * from Subject;

-- Заполнение таблицы Teacher
INSERT INTO Teacher (TeacherID, FullName, DepartmentID, Role) VALUES
(1, 'Иванова Ольга Николаевна', 1, 'Профессор'),
(2, 'Петрова Анна Викторовна', 2, 'Доцент'),
(3, 'Сидорова Мария Петровна', 3, 'Ассистент'),
(4, 'Алексеева Светлана Андреевна', 4, 'Старший преподаватель');
select * from Teacher;

-- Заполнение таблицы Department
INSERT INTO Department (DepartmentID, DepartmentName) VALUES
(1, 'Кафедра программирования'),
(2, 'Кафедра математики'),
(3, 'Кафедра физики'),
(4, 'Кафедра искусств');
select * from Department;

-- Заполнение таблицы DepartmentFaculty
INSERT INTO DepartmentFaculty (DepartmentFacultyID, FacultyID, DepartmentID) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4);
select * from DepartmentFaculty;

-- Заполнение таблицы TeacherSubject
INSERT INTO TeacherSubject (SemesterNumber, TeacherID, SubjectID) VALUES
(3, 1, 1),
(3, 2, 2),
(3, 3, 3),
(3, 4, 4);
select * from TeacherSubject;

-- Заполнение таблицы StudentSubject
INSERT INTO StudentSubject (StudentSubjectID, StudentID, SubjectID, SemesterNumber) VALUES
(1, 1, 1, 3),
(2, 2, 2, 3),
(3, 3, 3, 3);
select * from StudentSubject;

-- Заполнение таблицы Grades
INSERT INTO Grades (GradeID, StudentSubjectID, Grade, Date) VALUES
(4, 1, 8.50, '2024-06-01'),
(5, 2, 7.00, '2024-06-01');
select * from Grades;


-- Последовательность для генерации уникального ScholarshipID:
CREATE SEQUENCE seq_scholarship_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- Последовательность для генерации уникального StudentID:
CREATE SEQUENCE seq_student_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- Последовательность для генерации уникального GroupID:
CREATE SEQUENCE seq_group_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- Последовательность для генерации уникального FacultyID:
CREATE SEQUENCE seq_faculty_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- Последовательность для генерации уникального SubjectID:
CREATE SEQUENCE seq_subject_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- Последовательность для генерации уникального TeacherID:
CREATE SEQUENCE seq_teacher_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- Последовательность для генерации уникального DepartmentID:
CREATE SEQUENCE seq_department_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- Последовательность для генерации уникального DepartmentFacultyID:
CREATE SEQUENCE seq_department_faculty_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- Последовательность для генерации уникального StudentSubjectID:
CREATE SEQUENCE seq_student_subject_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- Последовательность для генерации уникального GradeID:
CREATE SEQUENCE seq_grade_id
START WITH 1
INCREMENT BY 1
NO MAXVALUE;

-- Индекс на таблице Student по полю GroupID:
CREATE INDEX idx_student_group ON Student(GroupID);

-- Индекс на таблице Grades по полю StudentSubjectID:
CREATE INDEX idx_grades_student_subject ON Grades(StudentSubjectID);

-- Индекс на таблице Subject по полю GroupID:
CREATE INDEX idx_subject_group ON Subject(GroupID);

-- Индекс на таблице Teacher по полю DepartmentID:
CREATE INDEX idx_teacher_department ON Teacher(DepartmentID);

-- Индекс на таблице Subject по полю SubjectName:
CREATE INDEX idx_subject_name ON Subject(SubjectName);

-- Индекс на таблице Department по полю DepartmentName:
CREATE INDEX idx_department_name ON Department(DepartmentName);

GO
-- Представление для получения списка студентов с их группами и предметами:
CREATE or ALTER VIEW vw_student_subjects AS
SELECT 
    s.StudentID as [ID студента],
    s.FullName as [ФИО],
    g.GroupName as [Название группы],
    sub.SubjectName as [Название предмета]
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
-- Представление для получения информации о студентах и их стипендиях:
CREATE OR ALTER VIEW vw_student_scholarship AS
SELECT 
    s.StudentID AS [Идентификатор Студента],
    s.FullName AS [ФИО],
    s.DateOfBirth AS [Дата рождения],
    s.AdmissionYear AS [Год поступления],
    s.Address AS [Адрес],
    sch.ScholarshipAmount AS [Сумма стипендии],
    sch.IsFullOrPart AS [Тип стипендии]
FROM 
    Student s
LEFT JOIN 
    Scholarship sch ON s.ScholarshipID = sch.ScholarshipID;
GO

SELECT * FROM vw_student_scholarship;

GO
-- Представление для анализа успеваемости студентов:
CREATE OR ALTER VIEW vw_student_performance AS
SELECT 
    s.StudentID AS [Идентификатор студента],
    s.FullName AS [ФИО],
    AVG(g.Grade) AS [Средняя оценка]
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

-- Процедуры добавления студентов
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
    @FullName = 'Груша Полина Владимировна', 
    @DateOfBirth = '2004-09-10', 
    @AdmissionYear = 2023, 
    @GroupID = 1, 
	@ScholarshipID = 2,
    @Address = 'Улица Центральная, дом 2';

SELECT * FROM Student;

-- Процедура для удаления студента:
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
-- Процедура для добавления предмета:
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
    @SubjectName = 'История искусств', 
    @SubjectType = 'Лекции', 
    @GroupID = 4;

SELECT * FROM Subject;

GO

-- Процедура для удаления предмета:
CREATE OR ALTER PROCEDURE DeleteSubject
    @SubjectID INT
AS
BEGIN
    DELETE FROM Subject WHERE SubjectID = @SubjectID;
END;


EXEC DeleteSubject @SubjectID = 4;

SELECT * FROM Subject;

GO
-- Процедура для добавления преподавателя:
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
    @FullName = 'Волосач Елена Николаевна', 
    @DepartmentID = 2, 
    @Role = 'Старший преподаватель';

select * from Teacher;

GO
-- Процедура для удаления преподавателя
CREATE OR ALTER PROCEDURE DeleteTeacher
    @TeacherID INT
AS
BEGIN
    DELETE FROM Teacher WHERE TeacherID = @TeacherID;
END;

SELECT * FROM Teacher;

EXEC DeleteTeacher @TeacherID = 5; 


GO
-- Процедура для добавления новой оценки студенту:
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
-- Процедура для обновления оценки студента:
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
-- Процедура для удаления оценки студента:
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
-- Процедура для получения средней оценки студента:
CREATE OR ALTER PROCEDURE GetStudentAverageGrade
    @StudentID INT
AS
BEGIN
    SELECT AVG(g.Grade) AS [СредняяОценка]
    FROM Grades g
    JOIN StudentSubject ss ON g.StudentSubjectID = ss.StudentSubjectID
    WHERE ss.StudentID = @StudentID;
END;

EXEC GetStudentAverageGrade @StudentID = 1;

GO
-- Процедура для получения информации о преподавателе по его ID:
CREATE or ALTER PROCEDURE GetTeacherInfo
    @TeacherID INT
AS
BEGIN
    SELECT 
        t.FullName AS [ФИО],
        d.DepartmentName AS [Название кафедры],
        t.Role AS [Должность]
    FROM 
        Teacher t
    JOIN 
        Department d ON t.DepartmentID = d.DepartmentID
    WHERE 
        t.TeacherID = @TeacherID;
END;

EXEC GetTeacherInfo @TeacherID = 1;


GO
-- Процедура для получения всех студентов с их стипендиями:
CREATE or ALTER PROCEDURE GetStudentsWithScholarships
AS
BEGIN
    SELECT 
        s.StudentID AS [Идентификатор студента],
        s.FullName AS [ФИО],
        sc.ScholarshipAmount AS [Сумма стипендии],
        sc.IsFullOrPart AS [Тип стипендии]
    FROM 
        Student s
    LEFT JOIN 
        Scholarship sc ON s.StudentID = sc.StudentID;
END;

EXEC GetStudentsWithScholarships;

GO
-- Функция для получения количества студентов в группе:
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
SELECT dbo.GetStudentCountInGroup(1) AS [Количество cтудентов];

GO
-- Получение средней оценки по предмету
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
SELECT dbo.GetAverageGradeBySubject(1) AS [Средняя оценка по предмету];


GO
-- Триггер для обновления статуса стипендии при изменении успеваемости студента:
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
-- Триггер для удаления записей о преподавателе из связанных таблиц
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
-- Триггер для удаления данных о студенте из связанных таблиц
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
-- Триггер для удаления данных о предмете из связанных таблиц
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
