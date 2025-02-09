ALTER SEQUENCE seq_teacher_id RESTART;
ALTER SEQUENCE seq_department_id RESTART;

DELETE FROM TeacherHierarchy;
DELETE FROM Teacher;
DELETE FROM Department;
DELETE FROM DepartmentFaculty;

COMMIT;

select * from Teacher;
select * from Department;

ALTER TABLE Teacher
ADD ParentID NUMBER;



CREATE TABLE TeacherHierarchy (
    ParentTeacherID NUMBER,
    ChildTeacherID NUMBER,
    FOREIGN KEY (ParentTeacherID) REFERENCES Teacher(TeacherID),
    FOREIGN KEY (ChildTeacherID) REFERENCES Teacher(TeacherID)
);


CREATE OR REPLACE PROCEDURE AddTeacher (
    p_FullName IN NVARCHAR2,
    p_DepartmentID IN NUMBER,
    p_Role IN NVARCHAR2,
    p_ParentTeacherID IN NUMBER DEFAULT NULL 
) AS
    v_NewTeacherID NUMBER;
BEGIN
    SELECT seq_teacher_id.NEXTVAL INTO v_NewTeacherID FROM dual;

    INSERT INTO Teacher (TeacherID, FullName, DepartmentID, Role)
    VALUES (v_NewTeacherID, p_FullName, p_DepartmentID, p_Role);

    IF p_ParentTeacherID IS NOT NULL THEN
        INSERT INTO TeacherHierarchy (ParentTeacherID, ChildTeacherID)
        VALUES (p_ParentTeacherID, v_NewTeacherID);
    END IF;
END;



-- Вставка данных в таблицу Department
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (1, 'Кафедра математики');
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (2, 'Кафедра физики');
INSERT INTO Department (DepartmentID, DepartmentName) VALUES (3, 'Кафедра информатики');


SELECT * FROM Teacher;
SELECT * FROM TeacherHierarchy;


EXEC AddTeacher('Ректор Иван Иваныч', NULL, 'Ректор', NULL);

-- Кафедра математики (Факультет 1)
EXEC AddTeacher('Декан Иванова Ольга Николаевна', 1, 'Декан', 1);  -- Подчинён ректору
EXEC AddTeacher('Сидоров Петр Сергеевич', 1, 'Доцент', 2);          -- Подчинён декану
EXEC AddTeacher('Антонов Алексей Иванович', 1, 'Ассистент', 3);    -- Подчинён доценту

-- Кафедра физики (Факультет 2)
EXEC AddTeacher('Декан Петрова Анна Викторовна', 2, 'Декан', 1);  -- Подчинён ректору
EXEC AddTeacher('Волосаев Алексей Павлович', 2, 'Доцент', 5);      -- Подчинён декану
EXEC AddTeacher('Волосач Елена Николаевна', 2, 'Старший преподаватель', 6); -- Подчинён доценту

-- Кафедра информатики (Факультет 3)
EXEC AddTeacher('Декан Морозова Виктория Дмитриевна', 3, 'Декан', 1); -- Подчинён ректору
EXEC AddTeacher('Семенов Владимир Николаевич', 3, 'Доцент', 8);      -- Подчинён декану
EXEC AddTeacher('Кузнецов Павел Андреевич', 3, 'Ассистент', 9);     -- Подчинён доценту

-- 2
CREATE OR REPLACE PROCEDURE GetTeacherHierarchy(p_TeacherID IN NUMBER) IS
BEGIN
    FOR rec IN (
        SELECT t.TeacherID, 
               t.FullName, 
               LEVEL AS HierarchyLevel,
               SYS_CONNECT_BY_PATH(t.TeacherID, '/') AS HierarchyPath
        FROM Teacher t
        JOIN TeacherHierarchy th ON t.TeacherID = th.ChildTeacherID
        START WITH t.TeacherID = p_TeacherID
        CONNECT BY PRIOR th.ChildTeacherID = th.ParentTeacherID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.TeacherID || ' ' || rec.FullName || ' ' || rec.HierarchyPath || ' Level: ' || rec.HierarchyLevel);
    END LOOP;
END;


DECLARE
    CURSOR c IS 
        SELECT t.TeacherID, 
               t.FullName, 
               LEVEL AS HierarchyLevel,
               SYS_CONNECT_BY_PATH(t.TeacherID, '/') AS HierarchyPath  -- Изменено на TeacherID
        FROM Teacher t
        JOIN TeacherHierarchy th ON th.ChildTeacherID = t.TeacherID
        START WITH t.TeacherID = 5 
        CONNECT BY PRIOR t.TeacherID = th.ParentTeacherID; 
BEGIN
    FOR rec IN c LOOP
        DBMS_OUTPUT.PUT_LINE(rec.TeacherID || ' ' || rec.FullName || ' | Path: ' || rec.HierarchyPath || ' | Level: ' || rec.HierarchyLevel);
    END LOOP;
END;


CREATE OR REPLACE PROCEDURE MoveTeacherBranch (
    p_SourceTeacherID IN NUMBER, 
    p_TargetTeacherID IN NUMBER  
) IS
BEGIN
    UPDATE TeacherHierarchy
    SET ParentTeacherID = p_TargetTeacherID
    WHERE ChildTeacherID = p_SourceTeacherID 
       OR ChildTeacherID IN (SELECT ChildTeacherID
                             FROM TeacherHierarchy
                             START WITH ParentTeacherID = p_SourceTeacherID
                             CONNECT BY PRIOR ChildTeacherID = ParentTeacherID);

    COMMIT;
END;

BEGIN
    MoveTeacherBranch(3, 5);
END;

