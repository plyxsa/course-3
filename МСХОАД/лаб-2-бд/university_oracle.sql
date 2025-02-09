CREATE TABLE Scholarship (
    ScholarshipID NUMBER PRIMARY KEY,
    StudentID NUMBER,
    IsFullOrPart CHAR(1),
    ScholarshipAmount NUMBER(10, 2)
);

CREATE TABLE Student (
    StudentID NUMBER PRIMARY KEY,
    FullName NVARCHAR2(200),
    DateOfBirth DATE,
    AdmissionYear NUMBER,
    GroupID NUMBER,
    ScholarshipID NUMBER,
    Address NVARCHAR2(200),
    FOREIGN KEY (GroupID) REFERENCES "Group"(GroupID),
    FOREIGN KEY (ScholarshipID) REFERENCES Scholarship(ScholarshipID)
);

CREATE TABLE "Group" (
    GroupID NUMBER PRIMARY KEY,
    GroupName NVARCHAR2(200),
    FacultyID NUMBER,
    SemesterNumber NUMBER,
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID)
);

CREATE TABLE Faculty (
    FacultyID NUMBER PRIMARY KEY,
    FacultyName NVARCHAR2(200)
);

CREATE TABLE Subject (
    SubjectID NUMBER PRIMARY KEY,
    SubjectName NVARCHAR2(200),
    SubjectType NVARCHAR2(200),
    GroupID NUMBER,
    FOREIGN KEY (GroupID) REFERENCES "Group"(GroupID)
);

CREATE TABLE Teacher (
    TeacherID NUMBER PRIMARY KEY,
    FullName NVARCHAR2(200),
    DepartmentID NUMBER,
    Role NVARCHAR2(200),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Department (
    DepartmentID NUMBER PRIMARY KEY,
    DepartmentName NVARCHAR2(200)
);

CREATE TABLE DepartmentFaculty (
    DepartmentFacultyID NUMBER PRIMARY KEY,
    FacultyID NUMBER,
    DepartmentID NUMBER,
    FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE TeacherSubject (
    SemesterNumber NUMBER,
    TeacherID NUMBER,
    SubjectID NUMBER,
    PRIMARY KEY (SemesterNumber, TeacherID, SubjectID),
    FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID)
);

CREATE TABLE StudentSubject (
    StudentSubjectID NUMBER PRIMARY KEY,
    StudentID NUMBER,
    SubjectID NUMBER,
    SemesterNumber NUMBER,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID)
);

CREATE TABLE Grades (
    GradeID NUMBER PRIMARY KEY,
    StudentSubjectID NUMBER,
    Grade NUMBER(3, 2),
    "Date" DATE,
    FOREIGN KEY (StudentSubjectID) REFERENCES StudentSubject(StudentSubjectID)
);

-- Последовательность для генерации уникального ScholarshipID:
CREATE SEQUENCE seq_scholarship_id
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Последовательность для генерации уникального StudentID:
CREATE SEQUENCE seq_student_id
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Последовательность для генерации уникального GroupID:
CREATE SEQUENCE seq_group_id
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Последовательность для генерации уникального FacultyID:
CREATE SEQUENCE seq_faculty_id
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Последовательность для генерации уникального SubjectID:
CREATE SEQUENCE seq_subject_id
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Последовательность для генерации уникального TeacherID:
CREATE SEQUENCE seq_teacher_id
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Последовательность для генерации уникального DepartmentID:
CREATE SEQUENCE seq_department_id
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Последовательность для генерации уникального DepartmentFacultyID:
CREATE SEQUENCE seq_department_faculty_id
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Последовательность для генерации уникального StudentSubjectID:
CREATE SEQUENCE seq_student_subject_id
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Последовательность для генерации уникального GradeID:
CREATE SEQUENCE seq_grade_id
START WITH 1
INCREMENT BY 1
NOCACHE;


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


-- Представление для получения списка студентов с их группами и предметами:
CREATE OR REPLACE VIEW vw_student_subjects AS
SELECT 
    s.StudentID AS "ID студента",
    s.FullName AS "ФИО",
    g.GroupName AS "Название группы",
    sub.SubjectName AS "Название предмета"
FROM 
    Student s
JOIN 
    "Group" g ON s.GroupID = g.GroupID
JOIN 
    StudentSubject ss ON s.StudentID = ss.StudentID
JOIN 
    Subject sub ON ss.SubjectID = sub.SubjectID;

-- Запрос к представлению vw_student_subjects
SELECT * FROM vw_student_subjects;

-- Представление для получения информации о студентах и их стипендиях:
CREATE OR REPLACE VIEW vw_student_scholarship AS
SELECT 
    s.StudentID AS "Идентификатор Студента",
    s.FullName AS "ФИО",
    s.DateOfBirth AS "Дата рождения",
    s.AdmissionYear AS "Год поступления",
    s.Address AS "Адрес",
    sch.ScholarshipAmount AS "Сумма стипендии",
    sch.IsFullOrPart AS "Тип стипендии"
FROM 
    Student s
LEFT JOIN 
    Scholarship sch ON s.ScholarshipID = sch.ScholarshipID;

-- Запрос к представлению vw_student_scholarship
SELECT * FROM vw_student_scholarship;

-- Представление для анализа успеваемости студентов:
CREATE OR REPLACE VIEW vw_student_performance AS
SELECT 
    s.StudentID AS "Идентификатор студента",
    s.FullName AS "ФИО",
    AVG(g.Grade) AS "Средняя оценка"
FROM 
    Student s
JOIN 
    StudentSubject ss ON s.StudentID = ss.StudentID
JOIN 
    Grades g ON ss.StudentSubjectID = g.StudentSubjectID
GROUP BY 
    s.StudentID, s.FullName;

-- Запрос к представлению vw_student_performance
SELECT * FROM vw_student_performance;



-- Процедура добавления студентов
CREATE OR REPLACE PROCEDURE AddStudent(
    p_FullName IN NVARCHAR2,
    p_DateOfBirth IN DATE,
    p_AdmissionYear IN INT,
    p_GroupID IN INT,
    p_ScholarshipID IN INT,
    p_Address IN NVARCHAR2
) AS
    v_NewStudentID INT;
BEGIN
    SELECT seq_student_id.NEXTVAL INTO v_NewStudentID FROM dual;

    INSERT INTO Student (StudentID, FullName, DateOfBirth, AdmissionYear, GroupID, ScholarshipID, Address)
    VALUES (v_NewStudentID, p_FullName, p_DateOfBirth, p_AdmissionYear, p_GroupID, p_ScholarshipID, p_Address);
END;

BEGIN
    AddStudent(
        p_FullName => 'Груша Полина Владимировна',
        p_DateOfBirth => TO_DATE('2004-09-10', 'YYYY-MM-DD'),
        p_AdmissionYear => 2023,
        p_GroupID => 1,
        p_ScholarshipID => 2,
        p_Address => 'Улица Центральная, дом 2'
    );
END;

SELECT * FROM Student;

-- Процедура для удаления студента:
CREATE OR REPLACE PROCEDURE DeleteStudent(
    p_StudentID IN INT
) AS
BEGIN
    DELETE FROM Student WHERE StudentID = p_StudentID;
END;

BEGIN
    DeleteStudent(p_StudentID => 6);
END;

SELECT * FROM Student;

-- Процедура для добавления предмета:
CREATE OR REPLACE PROCEDURE AddSubject(
    p_SubjectName IN NVARCHAR2,
    p_SubjectType IN NVARCHAR2,
    p_GroupID IN INT
) AS
    v_NewSubjectID INT;
BEGIN
    -- Получение нового ID предмета
    SELECT seq_subject_id.NEXTVAL INTO v_NewSubjectID FROM dual;

    INSERT INTO Subject (SubjectID, SubjectName, SubjectType, GroupID)
    VALUES (v_NewSubjectID, p_SubjectName, p_SubjectType, p_GroupID);
END;

BEGIN
    AddSubject(
        p_SubjectName => 'История искусств',
        p_SubjectType => 'Лекции',
        p_GroupID => 4
    );
END;


SELECT * FROM Subject;

-- Процедура для удаления предмета:
CREATE OR REPLACE PROCEDURE DeleteSubject(
    p_SubjectID IN INT
) AS
BEGIN
    DELETE FROM Subject WHERE SubjectID = p_SubjectID;
END;

BEGIN
    DeleteSubject(p_SubjectID => 4);
END;

SELECT * FROM Subject;

-- Процедура для добавления преподавателя:
CREATE OR REPLACE PROCEDURE AddTeacher(
    p_FullName IN NVARCHAR2,
    p_DepartmentID IN INT,
    p_Role IN NVARCHAR2
) AS
    v_NewTeacherID INT;
BEGIN
    SELECT seq_teacher_id.NEXTVAL INTO v_NewTeacherID FROM dual;

    INSERT INTO Teacher (TeacherID, FullName, DepartmentID, Role)
    VALUES (v_NewTeacherID, p_FullName, p_DepartmentID, p_Role);
END;

BEGIN
    AddTeacher(
        p_FullName => 'Волосач Елена Николаевна',
        p_DepartmentID => 2,
        p_Role => 'Старший преподаватель'
    );
END;

SELECT * FROM Teacher;

-- Процедура для удаления преподавателя
CREATE OR REPLACE PROCEDURE DeleteTeacher(
    p_TeacherID IN INT
) AS
BEGIN
    DELETE FROM Teacher WHERE TeacherID = p_TeacherID;
END;

-- Пример вызова процедуры
BEGIN
    DeleteTeacher(p_TeacherID => 5);
END;

SELECT * FROM Teacher;

-- Процедура для добавления новой оценки студенту:
CREATE OR REPLACE PROCEDURE AddStudentGrade(
    p_StudentSubjectID IN INT,
    p_Grade IN NUMBER,
    p_Date IN DATE
) AS
    v_NewGradeID INT;
BEGIN
    -- Получение нового ID оценки
    SELECT seq_grade_id.NEXTVAL INTO v_NewGradeID FROM dual;

    INSERT INTO Grades (GradeID, StudentSubjectID, Grade, "Date")
    VALUES (v_NewGradeID, p_StudentSubjectID, p_Grade, p_Date);
END;

BEGIN
    AddStudentGrade(p_StudentSubjectID => 2, p_Grade => 8, p_Date => TO_DATE('2024-10-20', 'YYYY-MM-DD'));
END;

SELECT * FROM Grades;

-- Процедура для обновления оценки студента:
CREATE OR REPLACE PROCEDURE UpdateStudentGrade(
    p_GradeID IN INT,
    p_NewGrade IN NUMBER
) AS
BEGIN
    UPDATE Grades
    SET Grade = p_NewGrade
    WHERE GradeID = p_GradeID;
END;

-- Пример вызова процедуры
BEGIN
    UpdateStudentGrade(p_GradeID => 2, p_NewGrade => 5.00);
END;

SELECT * FROM Grades;

-- Процедура для удаления оценки студента:
CREATE OR REPLACE PROCEDURE DeleteStudentGrade(
    p_GradeID IN INT
) AS
BEGIN
    DELETE FROM Grades
    WHERE GradeID = p_GradeID;
END;

BEGIN
    DeleteStudentGrade(p_GradeID => 8);
END;

SELECT * FROM Grades;

-- Процедура для получения средней оценки студента:
CREATE OR REPLACE PROCEDURE GetStudentAverageGrade(
    p_StudentID IN INT
) AS
    v_AverageGrade NUMBER;
BEGIN
    SELECT AVG(g.Grade) INTO v_AverageGrade
    FROM Grades g
    JOIN StudentSubject ss ON g.StudentSubjectID = ss.StudentSubjectID
    WHERE ss.StudentID = p_StudentID;

    DBMS_OUTPUT.PUT_LINE('Средняя оценка: ' || v_AverageGrade);
END;

BEGIN
    GetStudentAverageGrade(p_StudentID => 1);
END;

-- Процедура для получения информации о преподавателе по его ID:
CREATE OR REPLACE PROCEDURE GetTeacherInfo(
    p_TeacherID IN INT
) AS
BEGIN
    FOR rec IN (
        SELECT 
            t.FullName AS "ФИО",
            d.DepartmentName AS "Название кафедры",
            t.Role AS "Должность"
        FROM 
            Teacher t
        JOIN 
            Department d ON t.DepartmentID = d.DepartmentID
        WHERE 
            t.TeacherID = p_TeacherID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ФИО: ' || rec."ФИО" || ', Название кафедры: ' || rec."Название кафедры" || ', Должность: ' || rec."Должность");
    END LOOP;
END;


BEGIN
    GetTeacherInfo(p_TeacherID => 1);
END;

-- Процедура для получения всех студентов с их стипендиями:
CREATE OR REPLACE PROCEDURE GetStudentsWithScholarships AS
BEGIN
    FOR rec IN (
        SELECT 
            s.StudentID AS "Идентификатор студента",
            s.FullName AS "ФИО",
            sc.ScholarshipAmount AS "Сумма стипендии",
            sc.IsFullOrPart AS "Тип стипендии"
        FROM 
            Student s
        LEFT JOIN 
            Scholarship sc ON s.StudentID = sc.StudentID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Идентификатор студента: ' || rec."Идентификатор студента" || ', ФИО: ' || rec."ФИО" || ', Сумма стипендии: ' || rec."Сумма стипендии" || ', Тип стипендии: ' || rec."Тип стипендии");
    END LOOP;
END;

BEGIN
    GetStudentsWithScholarships;
END;


-- Функция для получения количества студентов в группе:
CREATE OR REPLACE FUNCTION GetStudentCountInGroup(
    p_GroupID IN NUMBER
) RETURN NUMBER IS
    v_StudentCount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_StudentCount
    FROM Student
    WHERE GroupID = p_GroupID;

    RETURN v_StudentCount;
END GetStudentCountInGroup;

SELECT GetStudentCountInGroup(1) AS "Количество студентов" FROM dual;

-- Функция для получения средней оценки по предмету
CREATE OR REPLACE FUNCTION GetAverageGradeBySubject(
    p_SubjectID IN NUMBER
) RETURN NUMBER IS
    v_AverageGrade NUMBER(3, 2);
BEGIN
    SELECT AVG(g.Grade)
    INTO v_AverageGrade
    FROM Grades g
    JOIN StudentSubject ss ON g.StudentSubjectID = ss.StudentSubjectID
    WHERE ss.SubjectID = p_SubjectID;

    RETURN v_AverageGrade;
END GetAverageGradeBySubject;

SELECT GetAverageGradeBySubject(1) AS "Средняя оценка по предмету" FROM dual;


-- Триггер для удаления записей о преподавателе из связанных таблиц
CREATE OR REPLACE TRIGGER trg_DeleteTeacher
BEFORE DELETE ON Teacher
FOR EACH ROW
BEGIN
    DELETE FROM TeacherSubject WHERE TeacherID = :OLD.TeacherID;
END trg_DeleteTeacher;


-- Триггер для удаления данных о студенте из связанных таблиц
CREATE OR REPLACE TRIGGER trg_DeleteStudent
BEFORE DELETE ON Student
FOR EACH ROW
DECLARE
BEGIN
    DELETE FROM Grades
    WHERE StudentSubjectID IN (
        SELECT StudentSubjectID 
        FROM StudentSubject 
        WHERE StudentID = :OLD.StudentID
    );

    DELETE FROM StudentSubject
    WHERE StudentID = :OLD.StudentID;

    DELETE FROM Student
    WHERE StudentID = :OLD.StudentID;

END trg_DeleteStudent;

-- Триггер для удаления данных о предмете из связанных таблиц
CREATE OR REPLACE TRIGGER trg_DeleteSubject
BEFORE DELETE ON Subject
FOR EACH ROW
DECLARE
BEGIN
    DELETE FROM Grades
    WHERE StudentSubjectID IN (
        SELECT StudentSubjectID 
        FROM StudentSubject 
        WHERE SubjectID = :OLD.SubjectID
    );

    DELETE FROM StudentSubject
    WHERE SubjectID = :OLD.SubjectID;

    DELETE FROM TeacherSubject
    WHERE SubjectID = :OLD.SubjectID;

    DELETE FROM Subject
    WHERE SubjectID = :OLD.SubjectID;

END trg_DeleteSubject;

CREATE GLOBAL TEMPORARY TABLE TempScholarshipAmounts (
    StudentID NUMBER,
    ScholarshipAmount NUMBER(10, 2),
    IsFullOrPart CHAR(1)
) ON COMMIT PRESERVE ROWS;

CREATE OR REPLACE TRIGGER trg_UpdateScholarshipStatus
BEFORE INSERT OR UPDATE ON Grades
FOR EACH ROW
DECLARE
    v_AverageGrade NUMBER(3, 2);
BEGIN
    SELECT AVG(g.Grade)
    INTO v_AverageGrade
    FROM Grades g
    JOIN StudentSubject ss ON g.StudentSubjectID = ss.StudentSubjectID
    WHERE ss.StudentID = (SELECT StudentID FROM StudentSubject WHERE StudentSubjectID = :NEW.StudentSubjectID);
    
    IF v_AverageGrade >= 5 AND v_AverageGrade < 6 THEN
        INSERT INTO TempScholarshipAmounts (StudentID, ScholarshipAmount, IsFullOrPart)
        VALUES (
            (SELECT StudentID FROM StudentSubject WHERE StudentSubjectID = :NEW.StudentSubjectID),
            200,
            'F'
        );
    ELSIF v_AverageGrade >= 6 AND v_AverageGrade < 7 THEN
        INSERT INTO TempScholarshipAmounts (StudentID, ScholarshipAmount, IsFullOrPart)
        VALUES (
            (SELECT StudentID FROM StudentSubject WHERE StudentSubjectID = :NEW.StudentSubjectID),
            300,
            'F'
        );
    ELSIF v_AverageGrade >= 7 AND v_AverageGrade < 8 THEN
        INSERT INTO TempScholarshipAmounts (StudentID, ScholarshipAmount, IsFullOrPart)
        VALUES (
            (SELECT StudentID FROM StudentSubject WHERE StudentSubjectID = :NEW.StudentSubjectID),
            400,
            'F'
        );
    ELSIF v_AverageGrade >= 8 AND v_AverageGrade < 9 THEN
        INSERT INTO TempScholarshipAmounts (StudentID, ScholarshipAmount, IsFullOrPart)
        VALUES (
            (SELECT StudentID FROM StudentSubject WHERE StudentSubjectID = :NEW.StudentSubjectID),
            500,
            'F'
        );
    ELSIF v_AverageGrade >= 9 THEN
        INSERT INTO TempScholarshipAmounts (StudentID, ScholarshipAmount, IsFullOrPart)
        VALUES (
            (SELECT StudentID FROM StudentSubject WHERE StudentSubjectID = :NEW.StudentSubjectID),
            600,
            'F'
        );
    ELSE
        INSERT INTO TempScholarshipAmounts (StudentID, ScholarshipAmount, IsFullOrPart)
        VALUES (
            (SELECT StudentID FROM StudentSubject WHERE StudentSubjectID = :NEW.StudentSubjectID),
            0,
            'P'
        );
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_UpdateScholarshipAfterGrades
AFTER INSERT OR UPDATE ON Grades
FOR EACH ROW
BEGIN
    MERGE INTO Scholarship s
    USING (SELECT StudentID, ScholarshipAmount, IsFullOrPart FROM TempScholarshipAmounts) t
    ON (s.StudentID = t.StudentID)
    WHEN MATCHED THEN
        UPDATE SET s.ScholarshipAmount = t.ScholarshipAmount, 
                   s.IsFullOrPart = t.IsFullOrPart
    WHEN NOT MATCHED THEN
        INSERT (s.StudentID, s.ScholarshipAmount, s.IsFullOrPart)
        VALUES (t.StudentID, t.ScholarshipAmount, t.IsFullOrPart);
END;



-- Заполнение таблицы Faculty
INSERT INTO Faculty (FacultyID, FacultyName)
VALUES (1, 'Факультет информационных технологий');

INSERT INTO Faculty (FacultyID, FacultyName)
VALUES (2, 'Факультет экономики');

INSERT INTO Faculty (FacultyID, FacultyName)
VALUES (3, 'Факультет менеджмента');

-- Заполнение таблицы Department
INSERT INTO Department (DepartmentID, DepartmentName)
VALUES (1, 'Кафедра программирования');

INSERT INTO Department (DepartmentID, DepartmentName)
VALUES (2, 'Кафедра сетевых технологий');

INSERT INTO Department (DepartmentID, DepartmentName)
VALUES (3, 'Кафедра менеджмента');

-- Заполнение таблицы DepartmentFaculty
INSERT INTO DepartmentFaculty (DepartmentFacultyID, FacultyID, DepartmentID)
VALUES (1, 1, 1);

INSERT INTO DepartmentFaculty (DepartmentFacultyID, FacultyID, DepartmentID)
VALUES (2, 1, 2);

INSERT INTO DepartmentFaculty (DepartmentFacultyID, FacultyID, DepartmentID)
VALUES (3, 2, 3);

-- Заполнение таблицы Group
INSERT INTO "Group" (GroupID, GroupName, FacultyID, SemesterNumber)
VALUES (1, 'Группа 101', 1, 1);

INSERT INTO "Group" (GroupID, GroupName, FacultyID, SemesterNumber)
VALUES (2, 'Группа 102', 1, 1);

INSERT INTO "Group" (GroupID, GroupName, FacultyID, SemesterNumber)
VALUES (3, 'Группа 201', 2, 2);

-- Добавление студентов
BEGIN
    AddStudent(
        p_FullName => 'Алексей Смирнов',
        p_DateOfBirth => TO_DATE('2000-03-15', 'YYYY-MM-DD'),
        p_AdmissionYear => 2022,
        p_GroupID => 1,
        p_ScholarshipID => NULL, -- Или укажите ID стипендии
        p_Address => 'Минск, ул. Ленина, 1'
    );

    AddStudent(
        p_FullName => 'Елена Коваленко',
        p_DateOfBirth => TO_DATE('2001-07-10', 'YYYY-MM-DD'),
        p_AdmissionYear => 2022,
        p_GroupID => 1,
        p_ScholarshipID => NULL,
        p_Address => 'Минск, ул. Советская, 2'
    );

    AddStudent(
        p_FullName => 'Дмитрий Иванов',
        p_DateOfBirth => TO_DATE('2000-12-05', 'YYYY-MM-DD'),
        p_AdmissionYear => 2022,
        p_GroupID => 2,
        p_ScholarshipID => NULL,
        p_Address => 'Минск, ул. Пролетарская, 3'
    );

    AddStudent(
        p_FullName => 'Ольга Петрова',
        p_DateOfBirth => TO_DATE('1999-08-20', 'YYYY-MM-DD'),
        p_AdmissionYear => 2021,
        p_GroupID => 3,
        p_ScholarshipID => NULL,
        p_Address => 'Минск, ул. Дружбы, 4'
    );
END;

-- Добавление преподавателей
BEGIN
    AddTeacher(
        p_FullName => 'Иванов И.И.',
        p_DepartmentID => 1,
        p_Role => 'Преподаватель'
    );

    AddTeacher(
        p_FullName => 'Петрова А.А.',
        p_DepartmentID => 2,
        p_Role => 'Доцент'
    );

    AddTeacher(
        p_FullName => 'Сидоров С.С.',
        p_DepartmentID => 1,
        p_Role => 'Старший преподаватель'
    );
END;

-- Заполнение таблицы Subject с использованием процедуры
BEGIN
    AddSubject(
        p_SubjectName => 'Программирование на Java',
        p_SubjectType => 'Лекция',
        p_GroupID => 1
    );

    AddSubject(
        p_SubjectName => 'Сетевые технологии',
        p_SubjectType => 'Лекция',
        p_GroupID => 1
    );

    AddSubject(
        p_SubjectName => 'Экономика',
        p_SubjectType => 'Семинар',
        p_GroupID => 2
    );

    AddSubject(
        p_SubjectName => 'Управление проектами',
        p_SubjectType => 'Лекция',
        p_GroupID => 3
    );
END;


-- Заполнение таблицы Scholarship
INSERT INTO Scholarship (ScholarshipID, StudentID, IsFullOrPart, ScholarshipAmount)
VALUES (1, 1, 'F', 300.00);

INSERT INTO Scholarship (ScholarshipID, StudentID, IsFullOrPart, ScholarshipAmount)
VALUES (2, 2, 'P', 200.00);

INSERT INTO Scholarship (ScholarshipID, StudentID, IsFullOrPart, ScholarshipAmount)
VALUES (3, 3, 'F', 400.00);

INSERT INTO Scholarship (ScholarshipID, StudentID, IsFullOrPart, ScholarshipAmount)
VALUES (4, 4, 'F', 500.00);

-- Заполнение таблицы StudentSubject
INSERT INTO StudentSubject (StudentSubjectID, StudentID, SubjectID, SemesterNumber)
VALUES (1, 1, 1, 1);

INSERT INTO StudentSubject (StudentSubjectID, StudentID, SubjectID, SemesterNumber)
VALUES (2, 1, 2, 1);

INSERT INTO StudentSubject (StudentSubjectID, StudentID, SubjectID, SemesterNumber)
VALUES (3, 2, 1, 1);

INSERT INTO StudentSubject (StudentSubjectID, StudentID, SubjectID, SemesterNumber)
VALUES (4, 3, 3, 2);

INSERT INTO StudentSubject (StudentSubjectID, StudentID, SubjectID, SemesterNumber)
VALUES (5, 4, 4, 2);

-- Использование процедуры для добавления оценок
BEGIN
    AddStudentGrade(
        p_StudentSubjectID => 1,
        p_Grade => 5.50,
        p_Date => TO_DATE('2023-05-15', 'YYYY-MM-DD')
    );

    AddStudentGrade(
        p_StudentSubjectID => 2,
        p_Grade => 6.75,
        p_Date => TO_DATE('2023-05-16', 'YYYY-MM-DD')
    );

    AddStudentGrade(
        p_StudentSubjectID => 3,
        p_Grade => 7.25,
        p_Date => TO_DATE('2023-05-17', 'YYYY-MM-DD')
    );

    AddStudentGrade(
        p_StudentSubjectID => 4,
        p_Grade => 8.50,
        p_Date => TO_DATE('2023-05-18', 'YYYY-MM-DD')
    );
END;







