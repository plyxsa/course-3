USE university;

ALTER SEQUENCE seq_teacher_id RESTART;
ALTER SEQUENCE seq_department_id RESTART;




delete from DepartmentFaculty;
delete from Department;
delete from Teacher;

select * from Department;


SELECT * FROM Teacher;

-- 1.Для базы данных в СУБД SQL Server добавить для одной из таблиц столбец данных иерархического типа. 
ALTER TABLE Teacher
ADD PositionHierarchy HIERARCHYID;

-- Изменение процедуры добавления сотрудников (3. Создать процедуру, которая добавит подчиненный узел (параметр – значение узла))
GO
CREATE OR ALTER PROCEDURE AddTeacher
    @FullName NVARCHAR(200),
    @DepartmentID INT,
    @Role NVARCHAR(200),
    @ParentTeacherID INT = NULL
AS
BEGIN
    DECLARE @NewTeacherID INT = NEXT VALUE FOR seq_teacher_id;
    DECLARE @PositionHierarchy HIERARCHYID;
    DECLARE @LastChild HIERARCHYID;
    DECLARE @ParentHierarchy HIERARCHYID;

    IF @ParentTeacherID IS NULL
    BEGIN
        SET @PositionHierarchy = HIERARCHYID::GetRoot();
    END
    ELSE
    BEGIN
        SELECT @ParentHierarchy = PositionHierarchy
        FROM Teacher
        WHERE TeacherID = @ParentTeacherID;

        SELECT @LastChild = MAX(PositionHierarchy)
        FROM Teacher
        WHERE PositionHierarchy.GetAncestor(1) = @ParentHierarchy;

        SET @PositionHierarchy = @ParentHierarchy.GetDescendant(@LastChild, NULL);
    END

    INSERT INTO Teacher (TeacherID, FullName, DepartmentID, Role, PositionHierarchy)
    VALUES (@NewTeacherID, @FullName, @DepartmentID, @Role, @PositionHierarchy);
END;


DECLARE @NewDepartmentID INT;

INSERT INTO Department (DepartmentID, DepartmentName)
VALUES 
    (NEXT VALUE FOR seq_department_id, 'Кафедра математики'),
    (NEXT VALUE FOR seq_department_id, 'Кафедра физики'),
    (NEXT VALUE FOR seq_department_id, 'Кафедра информатики'),
    (NEXT VALUE FOR seq_department_id, 'Кафедра химии'),
    (NEXT VALUE FOR seq_department_id, 'Кафедра биологии'),
    (NEXT VALUE FOR seq_department_id, 'Кафедра истории'),
    (NEXT VALUE FOR seq_department_id, 'Кафедра экономики');

SELECT * FROM Department;

GO
DECLARE @DepartmentID INT;
DECLARE @ParentTeacherID INT;

EXEC AddTeacher @FullName = 'Ректор Иван Иваныч', @DepartmentID = NULL, @Role = 'Ректор', @ParentTeacherID = NULL;

-- Кафедра математики (Факультет 1)
SET @DepartmentID = 1;
EXEC AddTeacher @FullName = 'Декан Иванова Ольга Николаевна', @DepartmentID = @DepartmentID, @Role = 'Декан', @ParentTeacherID = 1;
EXEC AddTeacher @FullName = 'Сидоров Петр Сергеевич', @DepartmentID = @DepartmentID, @Role = 'Доцент', @ParentTeacherID = 2;
EXEC AddTeacher @FullName = 'Антонов Алексей Иванович', @DepartmentID = @DepartmentID, @Role = 'Ассистент', @ParentTeacherID = 3;

-- Кафедра физики (Факультет 2)
SET @DepartmentID = 2;
EXEC AddTeacher @FullName = 'Декан Петрова Анна Викторовна', @DepartmentID = @DepartmentID, @Role = 'Декан', @ParentTeacherID = 1;
EXEC AddTeacher @FullName = 'Волосаев Алексей Павлович', @DepartmentID = @DepartmentID, @Role = 'Доцент', @ParentTeacherID = 5;
EXEC AddTeacher @FullName = 'Волосач Елена Николаевна', @DepartmentID = @DepartmentID, @Role = 'Старший преподаватель', @ParentTeacherID = 6;

-- Кафедра информатики (Факультет 3)
SET @DepartmentID = 3;
EXEC AddTeacher @FullName = 'Декан Морозова Виктория Дмитриевна', @DepartmentID = @DepartmentID, @Role = 'Декан', @ParentTeacherID = 1;
EXEC AddTeacher @FullName = 'Семенов Владимир Николаевич', @DepartmentID = @DepartmentID, @Role = 'Доцент', @ParentTeacherID = 8;
EXEC AddTeacher @FullName = 'Кузнецов Павел Андреевич', @DepartmentID = @DepartmentID, @Role = 'Ассистент', @ParentTeacherID = 9;
DECLARE @DepartmentID INT;
DECLARE @ParentTeacherID INT;
EXEC AddTeacher @FullName = 'Кузнецов Павел Андреевич', @DepartmentID = @DepartmentID, @Role = 'Ассистент', @ParentTeacherID = 13;


-- 2.Создать процедуру, которая отобразит все подчиненные узлы с указанием уровня иерархии (параметр – значение узла).
GO
CREATE PROCEDURE GetTeacherHierarchy
    @TeacherID INT
AS
BEGIN
    DECLARE @HierarchyID HIERARCHYID;

    SELECT @HierarchyID = PositionHierarchy FROM Teacher WHERE TeacherID = @TeacherID;

    SELECT 
        T.TeacherID,
        T.FullName,
        T.Role,
        T.DepartmentID,
        T.PositionHierarchy.ToString() AS HierarchyPath,
        T.PositionHierarchy.GetLevel() AS HierarchyLevel
    FROM Teacher T
    WHERE T.PositionHierarchy.IsDescendantOf(@HierarchyID) = 1
    ORDER BY T.PositionHierarchy;
END;


EXEC GetTeacherHierarchy @TeacherID = 1;


-- 4.Создать процедуру, которая переместит всю подчиненную ветку (первый параметр – значение верхнего перемещаемого узла,
-- второй параметр – значение узла, в который происходит перемещение).
GO
CREATE OR ALTER PROCEDURE MoveTeacherBranch (
    @SourceTeacherID INT,
    @TargetTeacherID INT 
)
AS
BEGIN
    DECLARE @SourceHierarchy HIERARCHYID;
    DECLARE @TargetHierarchy HIERARCHYID;
    DECLARE @NewHierarchy HIERARCHYID;

    SELECT @SourceHierarchy = PositionHierarchy FROM Teacher WHERE TeacherID = @SourceTeacherID;

    SELECT @TargetHierarchy = PositionHierarchy FROM Teacher WHERE TeacherID = @TargetTeacherID;

    IF @TargetHierarchy.IsDescendantOf(@SourceHierarchy) = 1
    BEGIN
        RAISERROR('Невозможно переместить узел в его потомка', 16, 1);
        RETURN;
    END

    DECLARE @LastChild HIERARCHYID;
    SELECT @LastChild = MAX(PositionHierarchy) FROM Teacher WHERE PositionHierarchy.GetAncestor(1) = @TargetHierarchy;

    SET @NewHierarchy = @TargetHierarchy.GetDescendant(@LastChild, NULL);

    WITH CTE_Teachers AS (
        SELECT TeacherID, PositionHierarchy 
        FROM Teacher 
        WHERE PositionHierarchy.IsDescendantOf(@SourceHierarchy) = 1
    )

    UPDATE T 
    SET T.PositionHierarchy = CTE.PositionHierarchy.GetReparentedValue(@SourceHierarchy, @NewHierarchy) 
    FROM Teacher T 
    JOIN CTE_Teachers CTE ON T.TeacherID = CTE.TeacherID;
END;

EXEC MoveTeacherBranch @SourceTeacherID = 5, @TargetTeacherID = 11;
EXEC GetTeacherHierarchy @TeacherID = 1;